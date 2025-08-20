/*
 * Highcharts Custom Stage Envelope Series Plugin
 *
 * This plugin creates a 'customstage' series type for Highcharts.
 * It renders individual tasks as rounded rectangles and wraps them all
 * in a smooth, semi-transparent "envelope" shape.
 *
 * It inherits from 'columnrange' to leverage its data processing.
 * Requires: highcharts.js and xrange.js
 */
(function (H) {
    'use strict';

    // Ensure a suitable base series exists: prefer 'xrange', fallback to 'columnrange'
    const baseSeries = H.seriesTypes.xrange || H.seriesTypes.columnrange;
    const baseTypeName = H.seriesTypes.xrange ? 'xrange' : (H.seriesTypes.columnrange ? 'columnrange' : null);
    if (!baseTypeName) {
        console.error("Highcharts Error: The 'customstage' series requires either the 'xrange' or 'columnrange' series type. Please load xrange.js or highcharts-more.js before this plugin.");
        return;
    }

    const { pick, seriesType } = H;

    seriesType('customstage', baseTypeName,
        // --- 1. Default Series Options ---
        {
            // Options for individual task bars
            borderRadius: 6,
            verticalMargin: 10,
            // Minimum width (in px) to show a bar, even if x==x2
            minPointWidthPx: 3,
            // Ensure hover/tooltip works
            enableMouseTracking: true,
            trackByArea: true,
            // Options for the envelope shape
            envelope: {
                enabled: true,
                color: 'auto', // 'auto' for gradient, or a specific color string
                externalRadius: 10,
                opacity: 0.35,
                margin: 4,
                // Connect boxes even if there's a small horizontal gap (px)
                gapConnect: 6,
                // Mode: 'dilate' (only expanded rects) | 'connect' (rects + connectors)
                mode: 'dilate',
                // Whether to draw outer corner arc patches between boxes
                arcs: false,
                // Slight overlap of shapes to hide seams (px)
                seamEpsilon: 0.5,
                // Blend amount for lane-to-lane color transition (0-0.3 typical)
                bandBlend: 0.08,
                // Render strategy: 'canvas' is the only supported method.
                strategy: 'canvas',
                // New: outline for better visibility
                stroke: 'rgba(0,0,0,0.18)',
                strokeWidth: 1.5,
                // New: glow shadow for envelope
                shadow: {
                    color: 'rgba(0, 120, 255, 0.25)',
                    offsetX: 0,
                    offsetY: 2,
                    opacity: 0.5,
                    width: 8
                }
            },
            // Disable hover animation to avoid parent drawPoint animations on custom graphics
            states: {
                hover: { enabled: false },
                inactive: { opacity: 1 }
            }
        },

        // --- 2. Series Prototype ---
        {
            // Initialize canvas overlay for hybrid rendering
            init: function () {
                const result = H.Series.prototype.init.apply(this, arguments);
                this.setupCanvasOverlay();
                return result;
            },

            // Setup offscreen canvas for envelope rendering (no DOM insertion)
            setupCanvasOverlay: function () {
                if (this.envelopeCanvas) {
                    this.cleanupCanvasOverlay();
                }
                // Create offscreen canvas and 2D context
                this.envelopeCanvas = document.createElement('canvas');
                this.envelopeCanvas.style.pointerEvents = 'none';
                this.envelopeCtx = this.envelopeCanvas.getContext('2d');
                // Size to plot area
                this.updateCanvasPosition();
            },

            // Update offscreen canvas size to match plot area
            updateCanvasPosition: function () {
                if (!this.envelopeCanvas) return;

                const chart = this.chart;
                const plotWidth = Math.round(chart.plotWidth);
                const plotHeight = Math.round(chart.plotHeight);

                // Use DPR=1 for 1:1 embedding into SVG image
                const dpr = 1;
                this.envelopeCanvas.width = plotWidth * dpr;
                this.envelopeCanvas.height = plotHeight * dpr;

                // Reset and reconfigure context each time
                this.envelopeCtx = this.envelopeCanvas.getContext('2d');
                this.envelopeCtx.setTransform(1, 0, 0, 1, 0, 0);
                this.envelopeCtx.scale(dpr, dpr);

                // Disable all smoothing for crisp edges
                this.envelopeCtx.imageSmoothingEnabled = false;
                this.envelopeCtx.webkitImageSmoothingEnabled = false;
                this.envelopeCtx.mozImageSmoothingEnabled = false;
                this.envelopeCtx.msImageSmoothingEnabled = false;
                this.envelopeCtx.oImageSmoothingEnabled = false;

                // Crisp line joins to avoid halos
                this.envelopeCtx.lineCap = 'square';
                this.envelopeCtx.lineJoin = 'miter';
                this.envelopeCtx.miterLimit = 10;
            },

            // Clean up offscreen canvas
            cleanupCanvasOverlay: function () {
                this.envelopeCanvas = null;
                this.envelopeCtx = null;
            },

            // --- Canvas Drawing Logic ---

            /**
             * Main function to draw the envelope shape onto the offscreen canvas.
             * @param {Array<Object>} allBoxes - Array of box dimensions.
             * @param {Object} envelopeOpts - Envelope configuration options.
             */
            drawEnvelopeOnCanvas: function (allBoxes, envelopeOpts) {
                if (!this.envelopeCtx || !allBoxes.length) return;

                const ctx = this.envelopeCtx;
                ctx.clearRect(0, 0, this.envelopeCanvas.width, this.envelopeCanvas.height);

                const path = new Path2D();

                // 1. Draw the base expanded shapes for all boxes.
                this.drawEnvelopeBaseShapes(path, allBoxes, envelopeOpts);

                // 2. If in 'connect' mode, draw connectors between boxes.
                if (envelopeOpts.mode === 'connect') {
                    this.drawEnvelopeConnectors(path, allBoxes, envelopeOpts);
                }

                // 3. Apply fill, shadow, and other styles to the final path.
                this.applyCanvasEnvelopeStyle(ctx, path, envelopeOpts, allBoxes);
            },

            /**
             * Adds the expanded rounded rectangles for each data point to the main path.
             * @param {Path2D} path - The main canvas path.
             * @param {Array<Object>} allBoxes - Array of box dimensions.
             * @param {Object} envelopeOpts - Envelope configuration options.
             */
            drawEnvelopeBaseShapes: function (path, allBoxes, envelopeOpts) {
                const { borderRadius } = this.options;
                const { margin, seamEpsilon: eps } = envelopeOpts;

                allBoxes.forEach(box => {
                    const expandedRadius = Math.min(borderRadius, box.width / 2) + margin;
                    const x = Math.round(box.x - margin - eps);
                    const y = Math.round(box.y - margin - eps);
                    const w = Math.round(box.width + margin * 2 + 2 * eps);
                    const h = Math.round(box.height + margin * 2 + 2 * eps);
                    this.addRoundedRectToPath(path, x, y, w, h, expandedRadius);
                });
            },

            /**
             * Adds connector shapes (vertical, horizontal, and corner arcs) to the path.
             * @param {Path2D} path - The main canvas path.
             * @param {Array<Object>} allBoxes - Array of box dimensions.
             * @param {Object} envelopeOpts - Envelope configuration options.
             */
            drawEnvelopeConnectors: function (path, allBoxes, envelopeOpts) {
                const { margin, gapConnect } = envelopeOpts;

                for (let i = 1; i < allBoxes.length; i++) {
                    const currentBox = allBoxes[i];
                    const prevBox = allBoxes[i - 1];

                    const shouldConnect = (currentBox.x - margin) <= (prevBox.x + prevBox.width + margin + gapConnect);
                    if (!shouldConnect) continue;

                    const sameLane = Math.abs(prevBox.y - currentBox.y) < 1;
                    if (sameLane) {
                        this.drawHorizontalConnector(path, prevBox, currentBox, envelopeOpts);
                    } else {
                        this.drawVerticalConnector(path, prevBox, currentBox, envelopeOpts);
                        if (envelopeOpts.arcs) {
                            this.drawCornerArcs(path, prevBox, currentBox, envelopeOpts);
                        }
                    }
                }
            },

            /**
             * Draws a horizontal connector between two boxes in the same lane.
             * @param {Path2D} path - The main canvas path.
             * @param {Object} prevBox - The preceding box.
             * @param {Object} currentBox - The current box.
             * @param {Object} envelopeOpts - Envelope configuration options.
             */
            drawHorizontalConnector: function (path, prevBox, currentBox, envelopeOpts) {
                const { margin, seamEpsilon: eps, connectorTrim, externalRadius } = envelopeOpts;
                const snapInt = Math.round;

                const rawStart = prevBox.x + prevBox.width + margin - eps;
                const rawEnd = currentBox.x - margin + eps;
                const barX = snapInt(rawStart + connectorTrim);
                const barW = snapInt((rawEnd - connectorTrim) - barX);

                if (barW > 0) {
                    const vTrim = Math.min(connectorTrim, externalRadius);
                    const topY = snapInt(Math.min(prevBox.y - margin, currentBox.y - margin) - eps + vTrim);
                    const bottomY = snapInt(Math.max(prevBox.y + prevBox.height + margin, currentBox.y + currentBox.height + margin) + eps - vTrim);
                    const barH = Math.max(0, bottomY - topY);
                    if (barH > 0) {
                        const connectorRadius = Math.max(1, externalRadius - Math.floor(vTrim / 2));
                        this.addRoundedRectToPath(path, barX, topY, barW, barH, connectorRadius);
                    }
                }
            },

            /**
             * Draws a vertical connector between two boxes in different lanes.
             * @param {Path2D} path - The main canvas path.
             * @param {Object} prevBox - The preceding box.
             * @param {Object} currentBox - The current box.
             * @param {Object} envelopeOpts - Envelope configuration options.
             */
            drawVerticalConnector: function (path, prevBox, currentBox, envelopeOpts) {
                const { borderRadius } = this.options;
                const { margin } = envelopeOpts;
                const isPrevLower = prevBox.y > currentBox.y;

                const height = isPrevLower
                    ? prevBox.y - currentBox.y - currentBox.height + borderRadius * 2
                    : currentBox.y - prevBox.y - prevBox.height + borderRadius * 2;
                const y = isPrevLower
                    ? currentBox.y + currentBox.height - borderRadius
                    : prevBox.y + prevBox.height - borderRadius;

                this.addRoundedRectToPath(path,
                    prevBox.x + prevBox.width + margin,
                    y + height,
                    currentBox.x - prevBox.x - prevBox.width - margin * 2,
                    -height,
                    0 // Connectors have sharp corners
                );
            },

            /**
             * Draws ECharts-style corner arcs for vertical transitions.
             * @param {Path2D} path - The main canvas path.
             * @param {Object} prevBox - The preceding box.
             * @param {Object} currentBox - The current box.
             * @param {Object} envelopeOpts - Envelope configuration options.
             */
            drawCornerArcs: function (path, prevBox, currentBox, envelopeOpts) {
                const { margin, externalRadius, arcsMode } = envelopeOpts;
                const isPrevLower = prevBox.y > currentBox.y;
                const sweep = (arcsMode === 'concave') ? 0 : 1; // Sweep flag determines arc direction

                const addArcPath = (svgPath) => {
                    try {
                        path.addPath(new Path2D(svgPath));
                    } catch (e) {
                        console.error("Error adding arc path to Path2D:", svgPath, e);
                    }
                };

                // --- Arc drawing logic, based on ECharts implementation ---
                if (isPrevLower) { // Previous box is below the current box
                    // Bottom-left corner arc
                    if (currentBox.x - margin > prevBox.x) {
                        const r = Math.min((currentBox.x - margin - prevBox.x) / 2, externalRadius);
                        if (r > 1) {
                            const right = Math.ceil(currentBox.x - margin);
                            const bottom = prevBox.y - margin;
                            addArcPath(`M${right - r} ${bottom}A${r} ${r} 0 0 ${sweep} ${right} ${bottom - r}L${right},${bottom + margin}L${right - r},${bottom}Z`);
                        }
                    }
                    // Top-right corner arc
                    if (currentBox.x + currentBox.width > prevBox.x + prevBox.width) {
                        const r = Math.min((currentBox.x + currentBox.width - prevBox.x - prevBox.width) / 2, externalRadius);
                        if (r > 1) {
                            const top = currentBox.y + currentBox.height + margin;
                            const left = Math.floor(prevBox.x + prevBox.width + margin);
                            addArcPath(`M${left + r} ${top}A${r} ${r} 0 0 ${sweep} ${left} ${top + r}L${left},${top - margin}L${left + r},${top}Z`);
                        }
                    }
                } else { // Previous box is above the current box
                    // Top-left corner arc
                    if (currentBox.x - margin > prevBox.x) {
                        const r = Math.min((currentBox.x - margin - prevBox.x) / 2, externalRadius);
                        if (r > 1) {
                            const right = Math.ceil(currentBox.x - margin);
                            const top = prevBox.y + prevBox.height + margin;
                            addArcPath(`M${right} ${top + r}A${r} ${r} 0 0 ${sweep} ${right - r} ${top}L${right},${top - margin}L${right},${top + r}Z`);
                        }
                    }
                    // Bottom-right corner arc
                    if (currentBox.x + currentBox.width > prevBox.x + prevBox.width) {
                        const r = Math.min((currentBox.x + currentBox.width - prevBox.x - prevBox.width) / 2, externalRadius);
                        if (r > 1) {
                            const bottom = currentBox.y - margin;
                            const left = Math.floor(prevBox.x + prevBox.width + margin);
                            addArcPath(`M${left} ${bottom - r}A${r} ${r} 0 0 ${sweep} ${left + r} ${bottom}L${left},${bottom + margin}L${left},${bottom - r}Z`);
                        }
                    }
                }
            },

            // Add rounded rectangle to Path2D with ultra-precision anti-seam technology
            addRoundedRectToPath: function (path, x, y, width, height, radius) {
                radius = Math.max(0, Math.min(radius || 0, Math.min(width, height) / 2));

                // Ultra-precise pixel alignment to eliminate seams
                x = Math.round(x * 8) / 8;
                y = Math.round(y * 8) / 8;
                width = Math.round(width * 8) / 8;
                height = Math.round(height * 8) / 8;
                radius = Math.round(radius * 8) / 8;

                if (radius === 0) {
                    path.rect(x, y, width, height);
                    return;
                }

                const x2 = x + width;
                const y2 = y + height;

                // Micro-overlap to eliminate seams completely
                const overlap = 0.005;

                path.moveTo(x + radius, y - overlap);
                path.lineTo(x2 - radius, y - overlap);
                path.arcTo(x2 + overlap, y - overlap, x2 + overlap, y + radius, radius);
                path.lineTo(x2 + overlap, y2 - radius);
                path.arcTo(x2 + overlap, y2 + overlap, x2 - radius, y2 + overlap, radius);
                path.lineTo(x + radius, y2 + overlap);
                path.arcTo(x - overlap, y2 + overlap, x - overlap, y2 - radius, radius);
                path.lineTo(x - overlap, y + radius);
                path.arcTo(x - overlap, y - overlap, x + radius, y - overlap, radius);
                path.closePath();
            },

            // Apply canvas envelope styling (gradient, shadow, opacity)
            applyCanvasEnvelopeStyle: function (ctx, path, envelopeOpts, allBoxes) {
                const opacity = pick(envelopeOpts.opacity, 0.35);

                // Save context state
                ctx.save();

                // Create gradient fill
                let fillStyle = envelopeOpts.color;
                if (fillStyle === 'auto') {
                    // Build a vertical gradient whose color transitions follow the vertical order of lanes
                    const canvasHeight = this.envelopeCanvas.height; // use offscreen canvas CSS pixels

                    // Group by color -> average vertical center
                    const colorMap = new Map();
                    allBoxes.forEach(b => {
                        const centerY = b.y + b.height / 2; // plot-local coords
                        if (!colorMap.has(b.color)) colorMap.set(b.color, []);
                        colorMap.get(b.color).push(centerY);
                    });

                    const entries = Array.from(colorMap.entries()).map(([color, arr]) => ({
                        color,
                        y: arr.reduce((a, v) => a + v, 0) / arr.length
                    }));

                    if (entries.length > 0) {
                        // Sort by vertical position (top -> bottom)
                        entries.sort((a, b) => a.y - b.y);
                        const gradient = ctx.createLinearGradient(0, 0, 0, canvasHeight);

                        const blend = Math.max(0, Math.min(0.3, pick(envelopeOpts.bandBlend, 0.08)));
                        // Build smooth stops around each lane center
                        entries.forEach((e, idx) => {
                            const pos = Math.max(0, Math.min(1, e.y / canvasHeight));
                            const prevPos = idx > 0 ? Math.max(0, Math.min(1, entries[idx - 1].y / canvasHeight)) : 0;
                            const nextPos = idx < entries.length - 1 ? Math.max(0, Math.min(1, entries[idx + 1].y / canvasHeight)) : 1;
                            const halfGapPrev = (pos - prevPos) * 0.5;
                            const halfGapNext = (nextPos - pos) * 0.5;
                            const left = Math.max(0, pos - Math.max(0.001, halfGapPrev * blend));
                            const right = Math.min(1, pos + Math.max(0.001, halfGapNext * blend));
                            // soft blend around the lane center
                            gradient.addColorStop(left, e.color);
                            gradient.addColorStop(pos, e.color);
                            gradient.addColorStop(right, e.color);
                        });
                        fillStyle = gradient;
                    } else {
                        fillStyle = '#88a';
                    }
                } else if (fillStyle && fillStyle.linearGradient) {
                    // Handle Highcharts gradient format
                    const grad = fillStyle.linearGradient;
                    const canvasHeight = this.envelopeCanvas.height; // CSS pixels
                    const canvasWidth = this.envelopeCanvas.width;  // CSS pixels
                    const gradient = ctx.createLinearGradient(
                        grad.x1 * canvasWidth,
                        grad.y1 * canvasHeight,
                        grad.x2 * canvasWidth,
                        grad.y2 * canvasHeight
                    );
                    fillStyle.stops.forEach(([offset, color]) => {
                        gradient.addColorStop(offset, color);
                    });
                    fillStyle = gradient;
                }

                // Apply shadow first (drawn behind the main shape)
                if (envelopeOpts.shadow) {
                    const shadow = envelopeOpts.shadow;
                    ctx.shadowColor = shadow.color || 'rgba(0, 0, 0, 0.3)';
                    ctx.shadowBlur = shadow.width || 8;
                    ctx.shadowOffsetX = shadow.offsetX || 0;
                    ctx.shadowOffsetY = shadow.offsetY || 2;

                    // Draw shadow pass
                    ctx.globalAlpha = opacity * (shadow.opacity || 0.5);
                    ctx.fillStyle = shadow.color || 'rgba(0, 0, 0, 0.3)';
                    ctx.fill(path);

                    // Reset shadow for main fill
                    ctx.shadowColor = 'transparent';
                    ctx.shadowBlur = 0;
                    ctx.shadowOffsetX = 0;
                    ctx.shadowOffsetY = 0;
                }

                // Draw main shape with crisp edges
                ctx.globalAlpha = opacity;
                ctx.fillStyle = fillStyle || '#88a';

                // Draw main shape with ultra-crisp multi-pass rendering

                // Pass 1: Base fill with enhanced coverage
                ctx.globalAlpha = opacity;
                ctx.fillStyle = fillStyle || '#88a';
                ctx.globalCompositeOperation = 'source-over';
                ctx.fill(path);

                // Pass 2: Edge reinforcement stroke to eliminate micro-gaps
                ctx.save();
                ctx.globalAlpha = opacity * 0.6;
                ctx.lineWidth = 0.3;
                ctx.strokeStyle = fillStyle || '#88a';
                ctx.globalCompositeOperation = 'source-atop';
                ctx.stroke(path);
                ctx.restore();

                // Pass 3: Final seamless overlay fill
                ctx.save();
                ctx.globalAlpha = opacity * 0.1;
                ctx.globalCompositeOperation = 'source-over';
                ctx.fill(path);
                ctx.restore();

                // Pass 4: Ultra-fine edge sealing (eliminates remaining artifacts)
                ctx.save();
                ctx.globalAlpha = opacity * 0.03;
                ctx.lineWidth = 0.1;
                ctx.strokeStyle = fillStyle || '#88a';
                ctx.globalCompositeOperation = 'color-burn';
                ctx.stroke(path);
                ctx.restore();

                // Restore context state
                ctx.restore();
            },
            // Override the main drawing function
            drawPoints: function () {
                const series = this;
                const chart = this.chart;
                const renderer = chart.renderer;
                const options = this.options;
                const yAxis = this.yAxis;

                // This will store the dimensions of all task bars
                const allBoxes = [];

                // Clean up any previous envelope graphic
                if (series.envelopeGroup) {
                    series.envelopeGroup.destroy();
                }
                series.envelopeGroup = renderer.g('envelope-group')
                    .attr({ zIndex: 1 }) // Draw envelope behind the bars
                    .add(series.group);
                // Do not block pointer events; let bars/tracker handle hover/click for tooltip
                if (series.envelopeGroup && series.envelopeGroup.css) {
                    series.envelopeGroup.css({ pointerEvents: 'none' });
                }

                const bandWidth = yAxis.transA; // Pixel height for one category lane

                // --- A. Draw each individual task bar ---
                series.points.forEach(point => {
                    if (point.isNull || !point.shapeArgs) return;

                    point.resolveColor(); // Get color for the point
                    const shapeArgs = point.shapeArgs;

                    // Calculate the actual bar dimensions inside the lane
                    const barHeight = bandWidth - (2 * options.verticalMargin);
                    // Start from base dimensions
                    const barShape = {
                        x: shapeArgs.x,
                        y: shapeArgs.y + options.verticalMargin,
                        width: shapeArgs.width,
                        height: barHeight,
                        r: options.borderRadius
                    };

                    // Ensure a minimum visible width for zero-duration ranges
                    const minW = Math.max(0, pick(options.minPointWidthPx, 3));
                    if (barShape.width < minW) {
                        const delta = (minW - barShape.width) / 2;
                        barShape.x = Math.round(barShape.x - delta);
                        barShape.width = minW;
                        // Keep inside plot area
                        const maxX = this.chart.plotWidth;
                        if (barShape.x < 0) {
                            barShape.width += barShape.x; // reduce width by overflow amount
                            barShape.x = 0;
                        }
                        if (barShape.x + barShape.width > maxX) {
                            barShape.width = Math.max(0, maxX - barShape.x);
                        }
                    }

                    // Draw the bar
                    if (point.graphic) point.graphic.destroy();
                    point.graphic = renderer.rect(barShape.x, barShape.y, barShape.width, barShape.height, barShape.r)
                        .attr({
                            fill: point.color,
                            zIndex: 2 // Bars on top of the envelope
                        })
                        .add(series.group);

                    // Rely on Highcharts' built-in tracker for hover/click/tooltip; no manual DOM events here

                    // Store dimensions for the envelope
                    allBoxes.push({ ...barShape, color: point.color });
                });

                // --- B. Draw the envelope shape ---
                const envelopeOpts = options.envelope || {};
                if (!envelopeOpts.enabled || allBoxes.length < 1) {
                    return;
                }

                const margin = pick(envelopeOpts.margin, 2);
                const externalRadius = pick(envelopeOpts.externalRadius, 8);
                const gapConnect = pick(envelopeOpts.gapConnect, 0);
                const drawArcs = envelopeOpts.arcs === true;
                const mode = envelopeOpts.mode || 'dilate';

                // Sort boxes by x, then by y for stable connections
                allBoxes.sort((a, b) => a.x - b.x || a.y - b.y);

                // Make sure tracker is present for tooltip/hover (use base series tracker)
                if (this.chart && this.chart.pointer && H.seriesTypes && (H.seriesTypes.xrange || H.seriesTypes.columnrange)) {
                    const Base = H.seriesTypes.xrange || H.seriesTypes.columnrange;
                    if (Base && Base.prototype && Base.prototype.drawTracker) {
                        Base.prototype.drawTracker.call(this);
                    } else if (H.Series && H.Series.prototype.drawTracker) {
                        H.Series.prototype.drawTracker.call(this);
                    }
                }

                // Determine envelope fill color
                let envelopeFill = envelopeOpts.color;
                if (envelopeFill === 'auto') {
                    const uniqueColors = [...new Set(allBoxes.map(b => b.color))];
                    const stops = uniqueColors.map((color, i, arr) => [(i * 2 + 1) / (arr.length * 2), color]);
                    envelopeFill = {
                        linearGradient: { x1: 0, y1: 0, x2: 0, y2: 1 },
                        stops: stops.length > 0 ? stops : [[0.5, '#88a']]
                    };
                }

                const envelopeStyle = {
                    fill: envelopeFill || '#88a',
                    'stroke-width': 0,
                    'shape-rendering': 'geometricPrecision'
                };

                const eps = pick(envelopeOpts.seamEpsilon, 0.5);

                // The only rendering strategy is canvas-based, baked into an SVG <image>.
                // Prepare offscreen canvas sized to plot area and draw.
                this.updateCanvasPosition();
                this.drawEnvelopeOnCanvas(allBoxes, envelopeOpts);

                // Replace previous image if any
                if (series._envImage) {
                    series._envImage.destroy();
                    series._envImage = null;
                }
                const dataUrl = this.envelopeCanvas.toDataURL('image/png');

                // Add as SVG image inside envelope group at plot (0,0)
                const img = renderer.image(
                    dataUrl,
                    0, 0,
                    chart.plotWidth, chart.plotHeight
                ).add(series.envelopeGroup);

                if (img && img.css) {
                    img.css({ pointerEvents: 'none' });
                }
                series._envImage = img;
            },

            // Clean up the envelope group on series destroy
            destroy: function () {
                this.cleanupCanvasOverlay();
                if (this.envelopeGroup) {
                    this.envelopeGroup.destroy();
                }
                return H.Series.prototype.destroy.apply(this, arguments);
            }
        },
        // --- 3. Point Class Overrides ---
        (function () {
            const BasePoint = H.seriesTypes[baseTypeName].prototype.pointClass;
            return {
                setState: function (state) {
                    // Fully bypass parent hover animation/drawPoint flow to avoid
                    // accessing undefined graphics; tooltip is handled by tracker
                    this.state = state;
                    return;
                }
            };
        })()
    );

}(Highcharts));

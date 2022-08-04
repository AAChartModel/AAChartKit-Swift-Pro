// Add new series type for the flame series

(function (H) {
    H.seriesType('flame', 'columnrange', {
        cursor: 'pointer',
        dataLabels: {
            enabled: true,
            format: '{point.name}',
            inside: true,
            align: 'center',
            crop: true,
            overflow: 'none',
            color: 'black',
            style: {
                textOutline: 'none',
                fontWeight: 'normal'
            }
        },
        point: {
            events: {
                click: function () {
                    var point = this,
                        chart = point.series.chart,
                        series = point.series,
                        xAxis = series.xAxis,
                        yAxis = series.yAxis;

                    xAxis.setExtremes(xAxis.min, point.x, false);
                    yAxis.setExtremes(point.low, point.high, false);

                    chart.showResetZoom();
                    chart.redraw();
                }
            }
        },
        pointPadding: 0,
        groupPadding: 0
    }, {
        drawDataLabels: H.seriesTypes.line.prototype.drawDataLabels
    });
}(Highcharts));

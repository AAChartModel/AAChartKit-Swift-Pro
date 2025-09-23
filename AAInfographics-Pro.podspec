Pod::Spec.new do |s|
    s.name         = 'AAInfographics-Pro'
    s.version      = '10.0.0'
    s.summary      = '📈📊👑👑👑AAChartKit-Swift-Pro is a professional version of AAChartKit-Swift, it is an elegant and friendly chart framework for iOS, iPadOS, macOS. AAChartKit-Swift-Pro is a more powerful data visualization framework that supports more types beautiful chart like bellcurve, bullet, columnpyramid, cylinder, dependencywheel, heatmap, histogram, networkgraph, organization, packedbubble, pareto, sankey, series, solidgauge, streamgraph, sunburst, tilemap, timeline, treemap, variablepie, variwide, vector, venn, windbarb, wordcloud, xrange charts and so on.'
    s.homepage      = 'https://github.com/AAChartModel/AAChartKit-Swift-Pro'
    s.license       = 'Just For Test Demo'
    s.authors       = {'An An' => '2236368544@qq.com'}
    s.ios.deployment_target = '11.0'
    s.osx.deployment_target = '10.13'
    s.source        = {:git => 'https://github.com/AAChartModel/AAChartKit-Swift-Pro.git', :tag => s.version}
    s.source_files  = 'AAInfographics-Pro/**/*.{swift}'
    s.exclude_files = 'AAInfographics-Pro/**/PackageBundlePathLoader.swift'
    s.resources     = "AAInfographics-Pro/AAJSFiles.bundle"
    s.requires_arc  = true
    s.swift_version = '5.0'
end

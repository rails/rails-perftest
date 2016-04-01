module Minitest
  def self.plugin_railsperftest_options(opts, options)
    make_sure_extension_order_is_good Minitest.extensions
    options[:railsperftest] = {}
    opts.on "--perf", "Run rails perfromance tests in profile mode" do
      options[:railsperftest][:enabled] = true
    end
    opts.on "--benchmark", "Run rails perfromance tests in profile mode" do
      options[:railsperftest][:enabled] = true
      options[:railsperftest][:benchmark] = true
    end
  end

  def self.plugin_railsperftest_init(options)
    if options[:railsperftest][:enabled]
      options[:patterns] = ["test/performance"]
    else
      options[:patterns] = Dir.glob('test/*').select { |f| File.directory?(f) && f != "test/performance" } if options[:patterns] == []
    end
    if options[:railsperftest][:benchmark]
      ENV["BENCHMARK_TESTS"] = '1'
    end
  end

  def self.make_sure_extension_order_is_good(extensions)
    if extensions.index("rails") && extensions.index("railsperftest") > extensions.index("rails")
      extensions.delete("railsperftest")
      extensions.unshift("railsperftest")
    end
  end
end
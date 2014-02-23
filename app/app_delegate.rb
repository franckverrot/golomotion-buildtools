class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    true
  end

  def foobar
    puts "AHAH: " + foo(2).to_s
  end
end

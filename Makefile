default: all

ll:
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -Os -S -arch i386 -emit-llvm foo.c -o foo.ll
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -Os -S -arch armv7 -emit-llvm foo.c -o foo-ios.ll
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -Os -S -arch x86_64 -emit-llvm foo.c -o foo-64.ll

s: 
	export PATH=/usr/local/llvm/3.0/bin/:$PATH
	#llc -march x86 foo.ll -o foo.s
	#llc -march x86-64 foo.ll -o foo-64.s
	#/Library/RubyMotion/bin/llc -march arm foo-ios.ll -o foo-ios.s
	llc -march x86 omg.ll -o foo.s
	llc -march x86-64 omg.ll -o foo-64.s
	#/Library/RubyMotion/bin/llc -march arm omg.ll -o foo-ios.s
	llc -march arm omg.ll -o foo-ios.s

o: 
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc  -arch armv7 -c foo-ios.s -o foo-ios.o
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc -arch i386 -c foo.s -o foo.o
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/cc -arch x86_64 -c foo-64.s -o foo-64.o

ar:

	file foo.o
	file foo-ios.o
	file foo-64.o

	lipo -info foo.o
	lipo -info foo-ios.o
	lipo -info foo-64.o

	ar crv foo.a foo.o
	ar crv foo-ios.a foo-ios.o
	ar crv foo-64.a foo-64.o
	lipo -create foo-ios.a foo.a -output vendor/foo/foo.a

all: ar

sim:
	@xcodebuild -configuration Debug -sdk iphonesimulator -project /Users/cesario/Documents/Rooms/GoloMotion/GoloMotion.xcodeproj
	@cp -r /Users/cesario/Documents/Rooms/GoloMotion/build/Debug-iphonesimulator/GoloMotion.app  .
	@echo "Building intermediary files..."
	@sleep 1
	@echo "Building Xcode bootloader..."
	@sleep 1
	ios-sim launch GoloMotion.app

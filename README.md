# INILua
Very basic INI file writing module for Lua with minimal format validation.

Each write opens and closes the file, so it's not meant for any situation where
performance is critical. It's mainly meant for easily writing small files.

# Usage
~~~
local my_settings = require("INILua")("my_settings.ini")

-- Write to global/default section.
my_settings:WriteKV("Foo", "Bar")

-- Start a section.
my_settings:WriteSection("Section 1")
my_settings:WriteKV("Foo", "Bar")

-- Start another section.
my_settings:WriteSection("Section 2")
my_settings:WriteKV("Foo", 1,2,3,4)
~~~

This will write out the following:
~~~
Foo = Bar

[Section 1]
Foo = Bar

[Section 2]
Foo = 1,2,3,4
~~~

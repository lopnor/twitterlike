use inc::Module::Install;
name 'TwitterLike';
all_from 'lib/TwitterLike.pm';

requires 'Ark';

tests 't/*.t';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;

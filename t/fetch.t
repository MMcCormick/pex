#!/bin/sh

. ./t/libtap.sh
. ./t/fixtures.sh

plan 6

pex init $test_repo_url

pex fetch foobar 2>/dev/null
ok 'pex fetch foobar succeeds' test $? -eq 0
ok 'archive was downloaded' test -f $HOME/.cache/pex/foobar/download/foobar.tar.gz

pex fetch foobar >stdout.out 2>/dev/null
ok 'archive was not downloaded again' grep -q 'Already' stdout.out

pex fetch foobaralias1 2>/dev/null
ok 'pex fetch alias succeeds' test $? -eq 0

ok_program 'pex fetch with nonexistent package fails' 1 'pex: package "nonexistent" does not exist' pex fetch nonexistent

ok 'pex fetch succeeds without pg_config' pex -g binx/ fetch foobar 2>/dev/null

cleanup

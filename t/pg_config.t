#!/bin/sh

. ./t/libtap.sh
. ./t/fixtures.sh

plan 9

pex init $test_repo_url


diag '-G option'

pex -G install foobar >stdout.out 2>/dev/null
ok 'option -G works' grep -q "PG_CONFIG=pg_config" stdout.out


diag '-g option'

rm -rf $tmpdir/share/postgresql/pex/installed/

pex -g $tmpdir install foobar >stdout.out 2>/dev/null
ok 'option -g with root dir works' grep -q "PG_CONFIG=$tmpdir/bin/pg_config" stdout.out

rm -rf $tmpdir/share/postgresql/pex/installed/

pex -g $tmpdir/bin install foobar >stdout.out 2>/dev/null
ok 'option -g with bin dir works' grep -q "PG_CONFIG=$tmpdir/bin/pg_config" stdout.out

rm -rf $tmpdir/share/postgresql/pex/installed/

pex -g $tmpdir/bin/pg_config install foobar >stdout.out 2>/dev/null
ok 'option -g with full path works' grep -q "PG_CONFIG=$tmpdir/bin/pg_config" stdout.out


diag '-d option'

rm -rf $tmpdir/share/postgresql/pex/installed/

pex -d $tmpdir/data install foobar >stdout.out 2>/dev/null
ok 'option -d works' grep -q "PG_CONFIG=$tmpdir/bin/pg_config" stdout.out


diag '-D option'

rm -rf $tmpdir/share/postgresql/pex/installed/

unset PGDATA

pex -D install foobar >stdout.out 2>/dev/null
grep -q "PG_CONFIG=$tmpdir/bin/pg_config" stdout.out
ok 'option -D without PGDATA set fails' test $? -ne 0

PGDATA=$tmpdir/data
export PGDATA

pex -D install foobar >stdout.out 2>/dev/null
ok 'option -D with PGDATA set works' grep -q "PG_CONFIG=$tmpdir/bin/pg_config" stdout.out


diag '-p option'

rm -rf $tmpdir/share/postgresql/pex/installed/

pex -p 5432 install foobar >stdout.out 2>stderr.out
grep -q "PG_CONFIG=$tmpdir/bin/pg_config" stdout.out && grep -q "psql -X -At -p 5432 -c show data_directory" stderr.out
ok 'option -p works' test $? -eq 0


diag '-P option'

rm -rf $tmpdir/share/postgresql/pex/installed/

pex -P install foobar >stdout.out 2>stderr.out
grep -q "PG_CONFIG=$tmpdir/bin/pg_config" stdout.out && grep -q "psql -X -At -c show data_directory" stderr.out
ok 'option -P works' test $? -eq 0


cleanup
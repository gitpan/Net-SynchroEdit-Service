# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Net-SynchroEdit-Service.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 20;
BEGIN { use_ok('Net::SynchroEdit::Service') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

use Net::SynchroEdit::Service ':all';

# Test 2
my $obj = new Net::SynchroEdit::Service;
ok($obj->connect,                     "connect using defaults (fails lest service runs @ localhost:7962)");

# Test 3
$obj = new Net::SynchroEdit::Service;
ok($obj->connect("localhost", 7962),  "connect using args (fails lest service runs @ localhost:7962)");

# Test 4
ok($obj->query("QUERY"),              "service query");

# Test 5
@qres = $obj->fetch_result;
ok(defined @qres,                     "queried result fetch");

# Test 6
$obj->query("INFO");
my %result = $obj->fetch_map;
ok(%result,                           "queried result fetch (as map)");
# Test 7.
ok(defined $result{'LOCALPATH'},      "queried result fetch (as map) - LOCALPATH check");
# Test 8.
ok(defined $result{'SERVERMODEL'},    "queried result fetch (as map) - SERVERMODEL check");
# Test 9.
ok(defined $result{'UPTIME'},         "queried result fetch (as map) - UPTIME check");

# Test 10
$obj->query("INFO");
my $line = $obj->fetch_status;
ok(defined $line,                     "queried result fetch (status)");

# Test 11
$obj->query("INIT testDocumentForService");
$obj->query("OPEN testDocumentForService");
my @ape = split(/ /, $obj->fetch_status());
my $sid = $ape[1];
$obj->fetch_status();

ok(defined $obj->shutdown($sid),      "shutdown");

# Test 12
my %sessions = $obj->sessions();
ok(%sessions,                         "sessions (non-extended)");

# Test 13
my @sids = split(/ /, $sessions{'SIDS'});
ok(@sids,                             "sessions - has entries (fails lest there are sessions)");

# Test 14
my %sdata = $obj->get($sids[0]);
ok(%sdata,                            "sessions - entry is hashmap");

# Test 15
ok(defined $sdata{'DOCUMENT'},        "sessions - entry has DOCUMENT key");

# Test 16
ok(!defined $sdata{'USERS'},       "sessions - entry doesn't have USERS key (not extended request)");

# Test 17
%sessions = $obj->sessions(1);
ok(%sessions,                         "sessions (extended)");

# Test 18
@sids  = split(/ /, $sessions{'SIDS'});
%sdata = $obj->get($sids[0]);
ok(defined $sdata{'USERS'},           "sessions - entry has USERS key (extended request)");

# Test 19
ok(defined $obj->fetch_info,          "fetch_info");

# Test 20
ok(defined $obj->disconnect,          "disconnect");

# Copyright (c) 2013 Peter Stuifzand
use strict;
use Marpa::R2;
use Data::Dumper;

my $g = Marpa::R2::Scanless::G->new({
        default_action => '::array',
        source         => \(<<'END_OF_SOURCE'),

:start        ::= rules
rules         ::= rule+

# include begin
rule          ::= cmd_type user
                | cmd_type list_ref
                | user_list

user_list  ::= user '=' user user

list_ref        ~ '@' username
user            ~ username
# include end


cmd_type        ~ 'Deny' | 'Allow'
username        ~ [\w]+

:discard        ~ ws
ws              ~ [\s]+

END_OF_SOURCE
});

my $re = Marpa::R2::Scanless::R->new({ grammar => $g });
my $input = <<'INPUT';
admins = admin root
Deny baduser
Allow @admins
INPUT

print "Trying to parse:\n$input\n\n";
$re->read(\$input);
my $value = ${$re->value};
print "Output:\n".Dumper($value);


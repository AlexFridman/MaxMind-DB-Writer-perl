use MaxMind::DB::Writer::Tree;
use JSON::Parse 'json_file_to_perl';
use JSON::Parse 'parse_json';
use warnings;

my ($config_path, $data_path, $output_path) = @ARGV;
my $configuration = json_file_to_perl($config_path);

my $tree = MaxMind::DB::Writer::Tree->new(
    ip_version            => $configuration->{ip_version},
    record_size           => $configuration->{record_size},
    database_type         => $configuration->{database_type},
    languages             => $configuration->{languages},
    description           => $configuration->{description},
    map_key_type_callback => sub { $configuration->{types}->{ $_[0] } },
);

if (open(my $fh, '<:encoding(UTF-8)', $data_path)) {
  while (my $row = <$fh>) {
    chomp $row;
    my $record = parse_json($row);
    $tree->insert_network($record->{network}, $record->{data});
  }
} else {
  warn "Could not open file '$data_path' $!";
}

open my $fh, '>:raw', $output_path;
$tree->write_tree($fh);
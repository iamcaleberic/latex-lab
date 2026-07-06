# Compilation Engine Configuration (Modern Default & Global Shell Escape)
$pdf_mode = 4; # Force compilation via LuaLaTeX directly to PDF
set_tex_cmds('--shell-escape %O %S'); # Native function applying shell-escape globally

# Operating System Dynamic Viewers
if ($^O eq 'darwin') {
    # macOS setup using Skim
    $pdf_previewer      = 'open -a Skim %O %S';
    $pdf_update_method  = 4; # Execute an external update command
    $pdf_update_command = '/Applications/Skim.app/Contents/SharedSupport/displayline -g %n %O %S';
} else {
    # Linux setup using Zathura
    $pdf_previewer     = 'zathura %O %S';
    $pdf_update_method = 0; # Zathura auto-reloads natively via inotify
}

# Clean Output & Directory Routing
$out_dir = 'build'; # Keeps root directory pristine
$aux_dir = 'build'; # Places temp logs, .aux, and .toc inside /build

# Citation and Bibliography Automations
$bibtex_use = 2; # Safely process biber/bibtex updates on changes
$biber      = 'biber %O %S';

# UX, Terminal Cleanliness, and Linter Silence
# Using 'our' prevents the Zed/perlnavigator "used only once" warning block
our $silence_logfile_warnings = 1;
our $max_repeat               = 5;
our $preview_behavior         = 1; # Don't close the viewer window between re-compiles
our $pvc_timeout              = 1; # Shut down continuous preview if idle

# Core Cleaner Array Extensions (Modern Array Pushes)
push @generated_exts, 'synctex.gz', 'bbl', 'blg', 'run.xml', 'fls', 'tex~';
push @generated_exts, 'slo', 'sls', 'slg', 'acr', 'acn', 'alg', 'glo', 'gls', 'glg';

# Global Asset Shield (Explicitly protects structural files from deletion)
sub protected_unlink {
    my @files = @_;
    foreach my $file (@files) {
        # Catch and shield critical documentation or metadata assets
        if ($file =~ /(README|LICENSE|CHANGELOG)/i) {
            print "🛡️  Asset Shield: Defended critical workspace file from deletion: $file\n";
        } else {
            unlink $file; # Safely wipe standard auxiliary junk
        }

    }
}
$unlink_cmd = \&protected_unlink;


# Convert EPS Vector Graphics to PDF automatically
add_cus_dep('eps', 'pdf', 0, 'eps2pdf');
sub eps2pdf {
   my $base = $_[0];
   return system("epstopdf \"$base.eps\"");
}

# Glossary & Nomenclature Compilations
add_cus_dep('slo', 'sls', 0, 'makeglossaries_hook');
add_cus_dep('acn', 'acr', 0, 'makeglossaries_hook');
add_cus_dep('glo', 'gls', 0, 'makeglossaries_hook');

sub makeglossaries_hook {
   my ($base_name, $path) = fileparse($_[0]);
   pushd $path;
   my $return = system "makeglossaries", $base_name;
   popd;
   return $return;
}

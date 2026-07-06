$pdflatex = 'lualatex -synctex=1 -interaction=nonstopmode %O %S';
# Detect the Operating System
if ($^O eq 'darwin') {
    # macOS setup using Skim
    $pdf_previewer = 'open -a Skim %O %S';
    $pdf_update_method = 4;
    $pdf_update_command = 'displayline -g %n %O %S';
} else {
    # Linux setup using Zathura
    $pdf_previewer = 'zathura %O %S';
    $pdf_update_method = 0; # Zathura auto-reloads natively
}

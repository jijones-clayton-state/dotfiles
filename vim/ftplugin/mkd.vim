setlocal formatoptions+=tn
setlocal textwidth=79
"setlocal formatlistpat=^\\s*(\\d\\+[\\]:.)}\\t\\ ]|\\*)\\s*
"setlocal formatlistpat=^\\s\*[\\*-\\s]\\s*
setlocal spell spelllang=en_gb
setlocal equalprg=pandoc\ -f\ markdown\ -t\ markdown\ --columns=79

$this | 
    Select-Xml -Namespace @{s='http://www.w3.org/2000/svg'} -XPath //s:font-face |
    Select-Object -ExpandProperty Node |
    Select-Object -ExpandProperty font-style
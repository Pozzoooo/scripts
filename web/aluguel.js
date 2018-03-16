
exemplo:
var empresa="AMBEV S/A";
var data="12/03/2018";

o que nos importa:
function newRow(empresa, data) {
	var link="http://www.bmfbovespa.com.br/pt_br/servicos/emprestimo-de-ativos/renda-variavel/emprestimos-registrados/renda-variavel-1.htm?f=A&dataConsulta";
	$.get(link, {empresaEmissora:empresa, data:data}, function(data) { 
		var test = document.createElement("test"); 
		test.innerHTML = data; 
		document.getElementsByTagName("tbody")[0].appendChild(test.getElementsByTagName("tr")[2]); 
	})
}

exemplo complexo:
for(i=1; i<15; ++i) { newRow("AMBEV S/A", i + "/03/2018"); }


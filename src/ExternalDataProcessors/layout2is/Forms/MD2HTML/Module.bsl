&НаКлиенте
Процедура ПолеHTMLДокументСформирован(Элемент)
	Document = Элементы.ПолеHTML.Документ;
	input = Document.getElementById("markdown-input");
	input.textContent = ТекстMD;
	Document.defaultView.convert();
    htmlCode = Document.htmlOutput.textContent;
    Document.defaultView.copyToClipboard(htmlCode);
	ПоказатьОповещениеПользователя("HTML код скопирован", , "Информация");
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПутьJS = ПолучитьИмяВременногоФайла(".js");
	showdown_min_js = ПолучитьИзВременногоХранилища(АдресJS);
	showdown_min_js.Записать(ПутьJS);
	MD2HTML_html = ПолучитьИзВременногоХранилища(АдресHTML);
	ТекстHTML = СтрЗаменить(MD2HTML_html.ПолучитьТекст(), "showdown.min.js", ПутьJS);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ТекстMD = Параметры.ТекстMD;
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	showdown_min_js = ОбработкаОбъект.ПолучитьМакет("showdown_min_js");
	АдресJS = ПоместитьВоВременноеХранилище(showdown_min_js);
	MD2HTML_html = ОбработкаОбъект.ПолучитьМакет("MD2HTML_html");
	АдресHTML = ПоместитьВоВременноеХранилище(MD2HTML_html);
КонецПроцедуры

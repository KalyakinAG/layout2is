//  Подсистема "Технология верстки статьи для Infostart"
//	Автор: Калякин Андрей Г.
//  https://github.com/KalyakinAG/layout2is
//  https://infostart.ru/1c/tools/2145718/

&НаКлиенте
Перем 
	ГраницаВыделения
;

&НаКлиенте
Функция Граница(НачалоСтроки, НачалоКолонки, КонецСтроки, КонецКолонки)
	Возврат Новый Структура("НачалоСтроки, НачалоКолонки, КонецСтроки, КонецКолонки", НачалоСтроки, НачалоКолонки, КонецСтроки, КонецКолонки);
КонецФункции

&НаКлиенте
Функция ПустаяГраница(Граница)
	Возврат Граница = Неопределено ИЛИ Граница.НачалоСтроки = Граница.КонецСтроки И Граница.НачалоКолонки = Граница.КонецКолонки;
КонецФункции

&НаКлиенте
Процедура УстановитьГраницу(ПолеТекста, ГраницаВыделения)
	ПолеТекста.УстановитьГраницыВыделения(ГраницаВыделения.НачалоСтроки, ГраницаВыделения.НачалоКолонки, ГраницаВыделения.КонецСтроки, ГраницаВыделения.КонецКолонки);
КонецПроцедуры

&НаКлиенте
Функция ПолучитьГраницу(ПолеТекста)
	Перем НачалоСтроки, НачалоКолонки, КонецСтроки, КонецКолонки;
	ПолеТекста.ПолучитьГраницыВыделения(НачалоСтроки, НачалоКолонки, КонецСтроки, КонецКолонки);
	Возврат Граница(НачалоСтроки, НачалоКолонки, КонецСтроки, КонецКолонки); 
КонецФункции

&НаКлиенте
Функция НайтиГраницуТекста(Текст, Подстрока, ГраницаНачала = Неопределено)
	Строки = СтрРазделить(Текст, Символы.ПС);
	Если ГраницаНачала = Неопределено Тогда
		НачальныйИндекс = 0;
		НачалоКолонкиПоиска = 1;
	Иначе
		НачальныйИндекс = ГраницаНачала.КонецСтроки - 1;
		НачалоКолонкиПоиска = ГраницаНачала.КонецКолонки;
	КонецЕсли;
	Для Индекс = НачальныйИндекс По Строки.ВГраница() Цикл
		Строка = Строки[Индекс];
		Если Индекс = НачальныйИндекс Тогда
			Если НачалоКолонкиПоиска > СтрДлина(Строка) Тогда
				Продолжить;
			КонецЕсли;
			НачалоКолонки = СтрНайти(Строка, Подстрока, , НачалоКолонкиПоиска);
		Иначе
			НачалоКолонки = СтрНайти(Строка, Подстрока);
		КонецЕсли;
		Если НачалоКолонки > 0 Тогда
			КонецКолонки = НачалоКолонки + СтрДлина(Подстрока); 
			НомерСтроки = Индекс + 1;
			Возврат Граница(НомерСтроки, НачалоКолонки, НомерСтроки, КонецКолонки);
		КонецЕсли;
	КонецЦикла;
	Возврат Неопределено;
КонецФункции

&НаКлиенте
Процедура НайтиИВыделитьВТекстеMD(СтрокаПоиска)
	ГраницаНачала = ПолучитьГраницу(Элементы.ТекстMD);
	Если ГраницаНачала.КонецКолонки > 1 ИЛИ ГраницаНачала.КонецСтроки > 1 Тогда
		ГраницаВыделения = НайтиГраницуТекста(ТекстMD, СтрокаПоиска, ГраницаНачала);
		Если ПустаяГраница(ГраницаВыделения) Тогда
			ГраницаВыделения = НайтиГраницуТекста(ТекстMD, СтрокаПоиска);
		КонецЕсли;
	Иначе
		ГраницаВыделения = НайтиГраницуТекста(ТекстMD, СтрокаПоиска);
	КонецЕсли;
	Если ПустаяГраница(ГраницаВыделения) Тогда
		Возврат;
	КонецЕсли;
	УстановитьГраницу(Элементы.ТекстMD, ГраницаВыделения);
	ТекущийЭлемент = Элементы.ТекстMD;
КонецПроцедуры

&НаКлиенте
Процедура КомандаНайтиВТексте(Команда)
	Изображение = Изображения.НайтиПоИдентификатору(Элементы.Изображения.ТекущаяСтрока);
	Если Элементы.Изображения.ТекущийЭлемент.Имя = "ИзображенияПуть" Тогда
		СтрокаПоиска = Изображение.Путь;
	Иначе
		СтрокаПоиска = Изображение.ИсходныйПуть;
	КонецЕсли;
	НайтиИВыделитьВТекстеMD(СтрокаПоиска);
КонецПроцедуры

&НаСервере
Функция ТаблицаЗначенийВМассив(ТаблицаЗначений) Экспорт
	
	Массив = Новый Массив();
	СтруктураСтрокой = "";
	НужнаЗапятая = Ложь;
	Для Каждого Колонка Из ТаблицаЗначений.Колонки Цикл
		Если НужнаЗапятая Тогда
			СтруктураСтрокой = СтруктураСтрокой + ",";
		КонецЕсли;
		СтруктураСтрокой = СтруктураСтрокой + Колонка.Имя;
		НужнаЗапятая = Истина;
	КонецЦикла;
	Для Каждого Строка Из ТаблицаЗначений Цикл
		НоваяСтрока = Новый Структура(СтруктураСтрокой);
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
		Массив.Добавить(НоваяСтрока);
	КонецЦикла;
	Возврат Массив;

КонецФункции

&НаКлиенте
Функция ПрочитатьДанныеИзФайлаJSON(ИмяФайла)
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.ОткрытьФайл(ИмяФайла, "UTF-8");
	Данные = ПрочитатьJSON(ЧтениеJSON);
	ЧтениеJSON.Закрыть();
	Возврат Данные;
КонецФункции

&НаКлиенте
Процедура ЗаписатьДанныеВФайлJSON(Данные, ИмяФайла)
	ПараметрыJSON = Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Авто, " ", Истина);
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.ОткрытьФайл(ИмяФайла, "UTF-8", , ПараметрыJSON);
	ЗаписатьJSON(ЗаписьJSON, Данные);
	ЗаписьJSON.Закрыть();
КонецПроцедуры

&НаСервере
Функция СписокИзображений()
	ТаблицаСсылок = Изображения.Выгрузить();
	МассивСтрок = ТаблицаЗначенийВМассив(ТаблицаСсылок);
	Возврат МассивСтрок;
КонецФункции
	
&НаКлиенте
Процедура КомандаСохранитьНастройки(Команда)
	Настройки = Новый Структура;
	Настройки.Вставить("Изображения", СписокИзображений());
	ЗаписатьДанныеВФайлJSON(Настройки, ПутьКПроекту + "\layout2is.json"); 
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаменитьТабуляцию(Команда)
	Строки = СтрРазделить(ТекстMD, Символы.ПС);
	ЭтоБлокТекста = Ложь;
	Для Индекс = 0 По Строки.ВГРаница() Цикл
		Строка = Строки[Индекс];
		Если СтрНачинаетсяС(Строка, "```") Тогда
			ЭтоБлокТекста = НЕ ЭтоБлокТекста;
		КонецЕсли;
		Если ЭтоБлокТекста Тогда
			Строки[Индекс] = СтрЗаменить(Строка, Символы.Таб, "    ");
		КонецЕсли;
	КонецЦикла;
	ТекстMD = СтрСоединить(Строки, Символы.ПС);
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаменитьСсылки(Команда)
	Для Каждого Изображение Из Изображения Цикл
		Если ПустаяСтрока(Изображение.ИсходныйПуть) ИЛИ ПустаяСтрока(Изображение.Путь) Тогда
			Продолжить;
		КонецЕсли;
		ТекстMD = СтрЗаменить(ТекстMD, Изображение.ИсходныйПуть, Изображение.Путь);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура КомандаНайтиСсылкиНаСервере()
	Словарь = Новый Соответствие;
	Для Каждого Изображение Из Изображения Цикл
		Словарь[Изображение.Имя] = Изображение;
	КонецЦикла;
	РегулярноеВыражение = РегулярноеВыражениеПоискСсылок();
	Результаты = СтрНайтиВсеПоРегулярномуВыражению(ТекстMD, РегулярноеВыражение, Истина, Истина);
	Для Каждого Результат Из Результаты Цикл
		Группы = Результат.ПолучитьГруппы();
		ИсходныйПуть = Группы[1].Значение;
		СоставПути = СтрРазделить(ИсходныйПуть, "/");
		Имя = СоставПути[СоставПути.ВГраница()];
		Изображение = Словарь[Имя];
		Если Изображение = Неопределено Тогда
			Изображение = Изображения.Добавить();
			Изображение.Имя = Имя;
			Словарь[Изображение.Имя] = Изображение;
		КонецЕсли;
		Изображение.Наименование = Группы[0].Значение;
		Изображение.ИсходныйПуть = ИсходныйПуть;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура КомандаНайтиСсылки(Команда)
	КомандаНайтиСсылкиНаСервере();
КонецПроцедуры

&НаКлиенте
Функция ПолучитьУровень(Заголовок) Экспорт
	Уровень = 0;
	Для НомерСимвола = 2 По 5 Цикл
		Символ = Сред(Заголовок, НомерСимвола, 1);
		Если Символ <> "#" Тогда
			Уровень = НомерСимвола - 1;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Возврат Уровень;
КонецФункции	

&НаКлиентеНаСервереБезКонтекста
Функция РегулярноеВыражениеПоискСсылок()
	РегулярноеВыражение = "\!\[(.*)\]\(((?:\/images\/|https:\/\/infostart\.ru\/)()[^)\s]+)\)";
	Возврат РегулярноеВыражение;
КонецФункции

//  slice
&НаКлиентеНаСервереБезКонтекста
Функция Срез(Элементы, НижняяГраница = 0, Знач ВерхняяГраница = Неопределено, Шаг = 1) Экспорт
	Если ВерхняяГраница = Неопределено Тогда
		ВерхняяГраница = Элементы.Количество();
	КонецЕсли;
	Результат = Новый Массив;
	Индекс = НижняяГраница;
	Пока Индекс < ВерхняяГраница Цикл
		Результат.Добавить(Элементы[Индекс]);
		Индекс = Индекс + Шаг;
	КонецЦикла;
	Возврат Результат;
КонецФункции

// Дополняет массив МассивПриемник значениями из массива МассивИсточник.
//
// Параметры:
//  МассивПриемник - Массив - массив, в который необходимо добавить значения.
//  МассивИсточник - Массив - массив значений для заполнения.
//  ТолькоУникальныеЗначения - Булево - если истина, то в массив будут включены только уникальные значения.
//
&НаКлиентеНаСервереБезКонтекста
Функция ДополнитьМассив(МассивПриемник, МассивИсточник, ТолькоУникальныеЗначения = Ложь, НижняяГраница = 0, Знач ВерхняяГраница = Неопределено, Шаг = 1) Экспорт
	Если ВерхняяГраница = Неопределено Тогда
		ВерхняяГраница = МассивИсточник.Количество();
	КонецЕсли;
	Индекс = НижняяГраница;
	Если ТолькоУникальныеЗначения Тогда
		УникальныеЗначения = Новый Соответствие;
		Для Каждого Значение Из МассивПриемник Цикл
			УникальныеЗначения.Вставить(Значение, Истина);
		КонецЦикла;
		Пока Индекс < ВерхняяГраница Цикл
			Значение = МассивИсточник[Индекс];
			Если УникальныеЗначения[Значение] = Неопределено Тогда
				МассивПриемник.Добавить(Значение);
				УникальныеЗначения.Вставить(Значение, Истина);
			КонецЕсли;
			Индекс = Индекс + Шаг;
		КонецЦикла;
	Иначе
		Пока Индекс < ВерхняяГраница Цикл
			МассивПриемник.Добавить(МассивИсточник[Индекс]);
			Индекс = Индекс + Шаг;
		КонецЦикла;
	КонецЕсли;
	Возврат МассивПриемник;
КонецФункции

// Формирует строку повторяющихся символов заданной длины.
//
// Параметры:
//  Символ      - Строка - символ, из которого будет формироваться строка.
//  ДлинаСтроки - Число  - требуемая длина результирующей строки.
//
// Возвращаемое значение:
//  Строка - строка, состоящая из повторяющихся символов.
//
&НаКлиентеНаСервереБезКонтекста
Функция СформироватьСтрокуСимволов(Знач Символ, Знач ДлинаСтроки) Экспорт
	
	Результат = "";
	Для Счетчик = 1 По ДлинаСтроки Цикл
		Результат = Результат + Символ;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура КомандаДобавитьОглавление(Команда)
	Перем Индекс, ИндексСтрокиTOC, Строка, Заголовок;
	Заголовки = Новый Массив;
	Строки = СтрРазделить(ТекстMD, Символы.ПС);
	МинУровень = 9;
	ЭтоБлокКомментария = Ложь;
	Пока Следующий(Индекс, Строка, Строки) Цикл
		Если ИндексСтрокиTOC = Неопределено Тогда
			Если Строка = "[TOC]" Тогда
				ИндексСтрокиTOC = Индекс;
			КонецЕсли;
			Продолжить;
		КонецЕсли;
		Если СтрНачинаетсяС(Строка, "```") Тогда
			ЭтоБлокКомментария = НЕ ЭтоБлокКомментария;
		КонецЕсли;
		Если ЭтоБлокКомментария ИЛИ НЕ СтрНачинаетсяС(Строка, "#") Тогда
			Продолжить;
		КонецЕсли;
		Уровень = ПолучитьУровень(Строка);
		МинУровень = Мин(МинУровень, Уровень);
		Заголовок = Прав(Строка, СтрДлина(Строка) - Уровень - 1);
		Заголовки.Добавить(Новый Структура("Заголовок, Уровень", Заголовок, Уровень));
	КонецЦикла;
	Если ИндексСтрокиTOC = Неопределено ИЛИ НЕ ЗначениеЗаполнено(Заголовки) Тогда
		Возврат;
	КонецЕсли;
	Список = Новый Массив;
	Список.Добавить("### Оглавление:");
	Для Каждого ЭлементЗаголовка Из Заголовки Цикл
		Отступ = СформироватьСтрокуСимволов(Символы.Таб, ЭлементЗаголовка.Уровень - МинУровень);
		Ссылка = СтрСоединить(СтрРазделить(НРег(ЭлементЗаголовка.Заголовок), " !*_():\/%,-""", Ложь), "-"); 
		Список.Добавить(СтрШаблон("%1- [%2](#%3)", Отступ, ЭлементЗаголовка.Заголовок, Ссылка)); 
	КонецЦикла;
	
	НовыеСтроки = Новый Массив;
	ДополнитьМассив(НовыеСтроки, Строки, , , ИндексСтрокиTOC);
	ДополнитьМассив(НовыеСтроки, Список);
	ДополнитьМассив(НовыеСтроки, Строки, , ИндексСтрокиTOC + 1);
	
	ТекстMD = СтрСоединить(НовыеСтроки, Символы.ПС);
КонецПроцедуры

&НаКлиенте
Функция ФайлСуществует(ИмяФайла)
	Файл = Новый Файл(ИмяФайла);
    Возврат Файл.Существует();
КонецФункции

&НаКлиенте
Процедура ПрочитатьНастройки()
	ИмяФайлаНастроек = ПутьКПроекту + "\layout2is.json";
	Если ФайлСуществует(ИмяФайлаНастроек) Тогда
		Настройки = ПрочитатьДанныеИзФайлаJSON(ИмяФайлаНастроек);
		Изображения.Очистить();
		Для Каждого Изображение Из Настройки.Изображения Цикл
			ЗаполнитьЗначенияСвойств(Изображения.Добавить(), Изображение);
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьТекстMD()
	ИмяФайлаТекстаMD = ПутьКПроекту + "\README.md";
	Если ФайлСуществует(ИмяФайлаТекстаMD) Тогда
		Текст = Новый ТекстовыйДокумент;
		Текст.Прочитать(ИмяФайлаТекстаMD, КодировкаТекста.UTF8);
		ТекстMD = Текст.ПолучитьТекст();
	Иначе
		ТекстMD = "Файл текста README.md в каталоге проекта НЕ НАЙДЕН!";
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Прочитать()
	ПрочитатьНастройки();
	ПрочитатьТекстMD();
КонецПроцедуры

&НаКлиенте
Процедура КомандаПрочитать(Команда)
	Прочитать();
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуПоИмени(Форма, ИмяФормы, Параметры = Неопределено, Уникальность = Неопределено, Окно = Неопределено, НавигационнаяСсылка = Неопределено, ОписаниеОповещенияОЗакрытии = Неопределено, РежимОткрытияОкна = Неопределено) Экспорт
//	Перем Уникальность, Окно, НавигационнаяСсылка, ОписаниеОповещенияОЗакрытии, РежимОткрытияОкна;
	Позиция = СтрНайти(Форма.ИмяФормы, ".", НаправлениеПоиска.СКонца);
	ПолноеИмяФормы = Лев(Форма.ИмяФормы, Позиция) + ИмяФормы;
	ОткрытьФорму(ПолноеИмяФормы, Параметры, Форма, Уникальность, Окно, НавигационнаяСсылка, ОписаниеОповещенияОЗакрытии, РежимОткрытияОкна);
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаполнитьПутьИзHTML(Команда)
	ОбработчикЗавершения = Новый ОписаниеОповещения("ОпределитьПутиСсылок", ЭтотОбъект);
	ОткрытьФормуПоИмени(ЭтотОбъект, "ДиалогВставкиДанныхИзHTML", , , , , ОбработчикЗавершения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

Функция JSONВОбъект(СтрокаJSON, ПрочитатьВСоответствие = Ложь) Экспорт
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(СтрокаJSON);
	Возврат ПрочитатьJSON(ЧтениеJSON, ПрочитатьВСоответствие);
КонецФункции

&НаКлиенте
Процедура ОпределитьПутиСсылок(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	Если РезультатЗакрытия = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Словарь = Новый Соответствие;
	Для Каждого Изображение Из Изображения Цикл
		Словарь[Изображение.Имя] = Изображение;
	КонецЦикла;
	НайденныеСсылки = JSONВОбъект(РезультатЗакрытия);
	Для Каждого Ссылка Из НайденныеСсылки Цикл
		//{name, href}
		Имя = Ссылка.name;
		Изображение = Словарь[Имя];
		Если Изображение = Неопределено Тогда
			Изображение = Изображения.Добавить();
			Изображение.Имя = Имя;
			Изображение.ИсходныйПуть = "/images/" + Имя;
		КонецЕсли;
		Изображение.Путь = Ссылка.href;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ПутьКПроектуНачалоВыбора(Элемент, ДанныеВыбора, ВыборДобавлением, СтандартнаяОбработка)
	ДиалогВыбораКаталога = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ДиалогВыбораКаталога.Заголовок = "Каталог проекта";
	Если НЕ ДиалогВыбораКаталога.Выбрать() Тогда
		Возврат;
	КонецЕсли;
    ПутьКПроекту = ДиалогВыбораКаталога.Каталог;
    Прочитать();
КонецПроцедуры

&НаКлиенте
Процедура codebeautifyНажатие(Элемент)
	ЗапуститьПриложение("https://codebeautify.org/markdown-to-html");
КонецПроцедуры

&НаКлиенте
Процедура ПутьКПроектуПриИзменении(Элемент)
	Прочитать();
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаменитьПуть(Команда)
	Для Каждого Изображение Из Изображения Цикл
		Если ПустаяСтрока(Изображение.ИсходныйПуть) ИЛИ ПустаяСтрока(Изображение.Путь) Тогда
			Продолжить;
		КонецЕсли;
		ТекстMD = СтрЗаменить(ТекстMD, Изображение.Путь, Изображение.ИсходныйПуть);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура КомандаОчиститьИзображения(Команда)
	Изображения.Очистить();
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция Следующий(Индекс, Элемент, Элементы, Шаг = 1)
	Если Индекс = Неопределено Тогда
		Индекс = 0;
	Иначе
		Индекс = Индекс + Шаг;
	КонецЕсли;
	Если Индекс > Элементы.ВГраница() Тогда
		Возврат Ложь;
	КонецЕсли;
	Элемент = Элементы[Индекс];
	Возврат Истина;
КонецФункции

&НаСервере
Процедура КомандаДобавитьПодписиНаСервере()
	Перем Индекс, Строка, Наименование;
	СловарьИсходныйПуть = Новый Соответствие;
	СловарьПуть = Новый Соответствие;
	Для Каждого Изображение Из Изображения Цикл
		СловарьИсходныйПуть[Изображение.ИсходныйПуть] = Изображение;
		СловарьПуть[Изображение.Путь] = Изображение;
	КонецЦикла;
	Строки = СтрРазделить(ТекстMD, Символы.ПС);
	РегулярноеВыражение = РегулярноеВыражениеПоискСсылок();
	ЭтоБлокКомментария = Ложь;
	Пока Следующий(Индекс, Строка, Строки) Цикл
		Если ЗначениеЗаполнено(Наименование) Тогда
			НаименованиеHTML = СтрШаблон("<p><span style=""font-size:9pt; font-family:'Arial'; color:#5b9bd5""><b>%1</b></span></p>", Наименование);
			Если СтрНачинаетсяС(Строка, "<span ") Тогда
				Строки[Индекс] = НаименованиеHTML;
			Иначе
				Строки.Вставить(Индекс, НаименованиеHTML);
			КонецЕсли;
			Наименование = "";
			Продолжить;
		КонецЕсли;
		Если СтрНачинаетсяС(Строка, "```") Тогда
			ЭтоБлокКомментария = НЕ ЭтоБлокКомментария;
		КонецЕсли;
		Если ЭтоБлокКомментария Тогда
			Продолжить;
		КонецЕсли;
		РезультатПоиска = СтрНайтиПоРегулярномуВыражению(Строка, РегулярноеВыражение, , , , Истина, Ложь);
		Если РезультатПоиска.НачальнаяПозиция = 0 Тогда
			Продолжить;
		КонецЕсли;
		Группы = РезультатПоиска.ПолучитьГруппы();
		Путь = Группы[1].Значение;
		ИзображениеИсходныйПуть = СловарьИсходныйПуть[Путь];
		ИзображениеПуть = СловарьПуть[Путь];
		Изображение = ?(ИзображениеПуть = Неопределено, ИзображениеИсходныйПуть, ИзображениеПуть);
		Если Изображение = Неопределено Тогда
			Наименование = Группы[0].Значение;
		Иначе
			Наименование = Изображение.Наименование;
		КонецЕсли;
	КонецЦикла;
	ТекстMD = СтрСоединить(Строки, Символы.ПС);
КонецПроцедуры

&НаКлиенте
Процедура КомандаДобавитьПодписи(Команда)
	КомандаДобавитьПодписиНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура КомандаВосстановитьНастройки(Команда)
	ПрочитатьНастройки();
КонецПроцедуры

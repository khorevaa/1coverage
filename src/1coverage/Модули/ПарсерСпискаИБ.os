#Использовать fs
#Использовать ParserFileV8i

Перем Лог;

Функция ОпределитьИдИБ(Знач СтрокаСоединенияСИБ) Экспорт

	Если Не ЗначениеЗаполнено(СтрокаСоединенияСИБ) Тогда
		ВызватьИсключение("Не указана строка соединения с ИБ");
	КонецЕсли;

	ТипИБ = Лев(СтрокаСоединенияСИБ, 2);

	Если ТипИБ = "/F" Тогда
		
		СтрокаСоединенияСИБ = Сред(СтрокаСоединенияСИБ, 3);
		СтрокаСоединенияСИБ = ФС.ПолныйПуть(СтрокаСоединенияСИБ);
	
	ИначеЕсли ТипИБ = "/S" Тогда

		СтрокаСоединенияСИБ = Сред(СтрокаСоединенияСИБ, 3);
		СтрокаСоединенияСИБ = СтрЗаменить(СтрокаСоединенияСИБ, "\", ":");

	Иначе

		ВызватьИсключение("Некорректно указан тип базы в строке соединения, ожидалось /F или /S");

	КонецЕсли;

	Лог.Отладка("Поиск ИБ "+ СтрокаСоединенияСИБ + " в файле ibases.v8i");
	
	ИдИнформационнойБазы = "";
	
	Парсер = Новый ПарсерСпискаБаз;
	СписокИБ = Парсер.НайтиПоПути(СтрокаСоединенияСИБ);

	Если ТипЗнч(СписокИБ) = Тип("Структура") Тогда
		ИдИнформационнойБазы = СписокИБ.ID;
		Лог.Отладка("ИБ "+ СтрокаСоединенияСИБ + " найдена в файле ibases.v8i с Ид=" + ИдИнформационнойБазы);
	Иначе
		Лог.Отладка("ИБ "+ СтрокаСоединенияСИБ + " не найдена в файле ibases.v8i");
	КонецЕсли;

	Если Не ЗначениеЗаполнено(ИдИнформационнойБазы) Тогда
		ВызватьИсключение("Не удалось определить Ид информационной базы " + СтрокаСоединенияСИБ);
	КонецЕсли;

	Возврат ИдИнформационнойБазы;

КонецФункции

Процедура ЗаменитьФайлСНастройкамиОтладкиДляБазы(Знач ИдИнформационнойБазы, Знач ПроксиХост, Знач ПроксиПорт) Экспорт

	КаталогФайлаНастроек = ПолучитьКаталогФайлаНастроек(ИдИнформационнойБазы);
	ИмяФайлаНастроек = ОбъединитьПути(КаталогФайлаНастроек, "1cv8.pfl");

	ПутьКФайлуШаблон = ОбъединитьПути(ПараметрыПриложения.КаталогПроекта, "fixtures", "1cv8.pfl");
	ЧтениеТекста = Новый ЧтениеТекста(ПутьКФайлуШаблон);
	СодержимоеФайла = ЧтениеТекста.Прочитать();
	ЧтениеТекста.Закрыть();

	СодержимоеФайла = СтрЗаменить(СодержимоеФайла, "%1COVERAGE_PROXY_HOST%", ПроксиХост);
	СодержимоеФайла = СтрЗаменить(СодержимоеФайла, "%1COVERAGE_PROXY_PORT%", ПроксиПорт);

	ЗаписьТекста = Новый ЗаписьТекста(ИмяФайлаНастроек);
	ЗаписьТекста.Записать(СодержимоеФайла);
	ЗаписьТекста.Закрыть();
	
КонецПроцедуры

Функция ПолучитьКаталогФайлаНастроек(Знач ИдИнформационнойБазы) Экспорт

	AppData = ПолучитьПеременнуюСреды("APPDATA");
	КаталогФайлаНастроек = ОбъединитьПути(AppData, "1C", "1cv8", ИдИнформационнойБазы);
	ФС.ОбеспечитьКаталог(КаталогФайлаНастроек);

	Возврат КаталогФайлаНастроек;

КонецФункции

Процедура Инициализация()
	
	Лог = ПараметрыПриложения.Лог();

КонецПроцедуры	

Инициализация();

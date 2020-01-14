#Использовать fs
#Использовать ParserFileV8i

Перем Лог;

Перем ПараметрыКоманды;

Перем СтрокаСоединенияСИБ;
Перем ПроксиХост;
Перем ПроксиПорт;

Процедура ОписаниеКоманды(Команда) Экспорт

	Команда.Опция("ib-connection", "", "строка соединения с информационной базой")
		.ТСтрока();
	Команда.Опция("dbgs-proxy-host", "", "хост прокси")
		.ТСтрока()
		.ПоУмолчанию("localhost");
	Команда.Опция("dbgs-proxy-port", "", "порт прокси")
		.ТСтрока()
		.ПоУмолчанию("3000");

КонецПроцедуры

Процедура ПередВыполнениемКоманды(Знач Команда) Экспорт

	Лог = ПараметрыПриложения.Лог();

	ПараметрыКоманды = Новый Соответствие();
	ПараметрыКоманды.Вставить("ib-connection", Команда.ЗначениеОпции("ib-connection"));
	ПараметрыКоманды.Вставить("dbgs-proxy-host", Команда.ЗначениеОпции("dbgs-proxy-host"));
	ПараметрыКоманды.Вставить("dbgs-proxy-port", Команда.ЗначениеОпции("dbgs-proxy-port"));

	СтрокаСоединенияСИБ = ПараметрыКоманды["ib-connection"];
	ПроксиХост = ПараметрыКоманды["dbgs-proxy-host"];
	ПроксиПорт = ПараметрыКоманды["dbgs-proxy-port"];

КонецПроцедуры

Процедура ВыполнитьКоманду(Знач Команда) Экспорт
	
	ИдИнформационнойБазы = ОпределитьИдИнформационнойБазы(СтрокаСоединенияСИБ);
	
	ЗаменитьФайлСНастройкамиОтладкиДляБазы(ИдИнформационнойБазы);

	Лог.Информация("Установлена http-отладка для базы, Ид " + ИдИнформационнойБазы);
	
КонецПроцедуры

Функция ОпределитьИдИнформационнойБазы(Знач СтрокаСоединенияСИБ)

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

Процедура ЗаменитьФайлСНастройкамиОтладкиДляБазы(ИдИнформационнойБазы)

	AppData = ПолучитьПеременнуюСреды("APPDATA");
	КаталогФайлаНастроек = ОбъединитьПути(AppData, "1C", "1cv8", ИдИнформационнойБазы);

	ИмяФайлаНастроек = ОбъединитьПути(КаталогФайлаНастроек, "1cv8.pfl");

	ЧтениеТекста = Новый ЧтениеТекста("./fixtures/1cv8.pfl");
	СодержимоеФайла = ЧтениеТекста.Прочитать();
	ЧтениеТекста.Закрыть();

	СодержимоеФайла = СтрЗаменить(СодержимоеФайла, "%1COVERAGE_PROXY_HOST%", ПроксиХост);
	СодержимоеФайла = СтрЗаменить(СодержимоеФайла, "%1COVERAGE_PROXY_PORT%", ПроксиПорт);

	ЗаписьТекста = Новый ЗаписьТекста(ИмяФайлаНастроек);
	ЗаписьТекста.Записать(СодержимоеФайла);
	ЗаписьТекста.Закрыть();
	
КонецПроцедуры

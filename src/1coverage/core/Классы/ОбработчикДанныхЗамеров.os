Перем ДанныеЗамеров;

Перем Лог;

Процедура ПриСозданииОбъекта(пДанныеЗамеров) Экспорт

	Лог = ПараметрыПриложения.Лог();

	ДанныеЗамеров = пДанныеЗамеров;

КонецПроцедуры

Функция ЗаполнитьДанныеПокрытия() Экспорт

	ДанныеПокрытия = ДанныеПокрытияИнициализация();

	Для Каждого ДанныеМодулейВЗамерах Из ДанныеЗамеров Цикл

		Если ТипЗнч(ДанныеМодулейВЗамерах) = Тип("Массив") Тогда
			Для Каждого ДанныеМодуляВЗамерах Из ДанныеМодулейВЗамерах Цикл
				ЗаполнитьДанныеМодуля(ДанныеМодуляВЗамерах, ДанныеПокрытия);
			КонецЦикла;
		Иначе
			ДанныеМодуляВЗамерах = ДанныеМодулейВЗамерах;
			ЗаполнитьДанныеМодуля(ДанныеМодуляВЗамерах, ДанныеПокрытия);
		КонецЕсли;
		
	КонецЦикла;

	Возврат ДанныеПокрытия;

КонецФункции

Функция ДанныеПокрытияИнициализация()

	ДанныеПокрытия = Новый ТаблицаЗначений();
	ДанныеПокрытия.Колонки.Добавить("ИдОбъекта");
	ДанныеПокрытия.Колонки.Добавить("ИдТипаМодуля");
	ДанныеПокрытия.Колонки.Добавить("ИмяФайла");
	ДанныеПокрытия.Колонки.Добавить("ПутьКОбъекту");
	ДанныеПокрытия.Колонки.Добавить("ИмяКоманды");
	ДанныеПокрытия.Колонки.Добавить("ИмяФормы");
	ДанныеПокрытия.Колонки.Добавить("ПутьКМодулю");
	ДанныеПокрытия.Колонки.Добавить("НомераСтрок");

	Возврат ДанныеПокрытия;

КонецФункции

Процедура ЗаполнитьДанныеМодуля(ДанныеМодуля, ДанныеПокрытия)

	ИдОбъекта = ДанныеМодуля.moduleID.objectID._text;
	ИдТипаМодуля = ДанныеМодуля.moduleID.propertyID._text;

	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("ИдОбъекта", ИдОбъекта);
	СтруктураОтбора.Вставить("ИдТипаМодуля", ИдТипаМодуля);

	НайденныеСтроки = ДанныеПокрытия.НайтиСтроки(СтруктураОтбора);

	Если НайденныеСтроки.Количество() = 1 Тогда
		СтрокаДанныхПокрытия = НайденныеСтроки[0];
	ИначеЕсли НайденныеСтроки.Количество() = 0 Тогда
		СтрокаДанныхПокрытия = ДанныеПокрытия.Добавить();
		СтрокаДанныхПокрытия.НомераСтрок = Новый Соответствие();
		СтрокаДанныхПокрытия.ИдОбъекта = ИдОбъекта;
		СтрокаДанныхПокрытия.ИдТипаМодуля = ИдТипаМодуля;
	Иначе
		ВызватьИсключение("Ошибка заполнения данных покрытия");
	КонецЕсли;
	
	Для Каждого СтрокаПокрытия Из ДанныеМодуля.lineInfo Цикл
		НомерСтрокиМодуля = СтрокаПокрытия.lineNo._text;
		Если СтрокаДанныхПокрытия.НомераСтрок[НомерСтрокиМодуля] <> Неопределено Тогда
			ТекущееКоличествоХитов = СтрокаДанныхПокрытия.НомераСтрок[НомерСтрокиМодуля] + 1;
		Иначе
			ТекущееКоличествоХитов = 1;
		КонецЕсли;
		
		СтрокаДанныхПокрытия.НомераСтрок.Вставить(СтрокаПокрытия.lineNo._text, ТекущееКоличествоХитов);
		
	КонецЦикла;
	
	Лог.Отладка("В замерах обнаружен объект с id " + ИдОбъекта);

КонецПроцедуры

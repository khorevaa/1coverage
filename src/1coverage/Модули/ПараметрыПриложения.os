#Использовать logos

Перем Лог;

Перем КаталогПроекта Экспорт;

Процедура Инициализация()

	КаталогПроекта = ОбъединитьПути(ТекущийСценарий().Каталог, "..", "..", "..");

КонецПроцедуры

Функция Лог() Экспорт
	
	Если Лог = Неопределено Тогда
		Лог = Логирование.ПолучитьЛог(ИмяЛогаПриложения());
	КонецЕсли;
	
	Возврат Лог;
	
КонецФункции

Функция ИмяЛогаПриложения() Экспорт
	Возврат "oscript.app." + ИмяПриложения();
КонецФункции

Функция ИмяПриложения() Экспорт
	
	Возврат "1coverage";
	
КонецФункции

Процедура УстановитьРежимОтладкиПриНеобходимости(Знач РежимОтладки) Экспорт
	
	Если РежимОтладки Тогда
		
		Лог().УстановитьУровень(УровниЛога.Отладка);
		Лог.Отладка("Установлен уровень логов ОТЛАДКА");
		
	КонецЕсли;
	
КонецПроцедуры

Функция Версия() Экспорт
	
	Возврат "1.0.0";
	
КонецФункции

Инициализация();

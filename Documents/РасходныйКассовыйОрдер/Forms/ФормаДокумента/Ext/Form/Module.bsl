﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если НЕ ЗначениеЗаполнено(Объект.Ответственный) Тогда
		Объект.Ответственный = ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли;
	
	НоваяСвязь = Новый СвязьПараметраВыбора("Отбор.Владелец", "Объект.Получатель");
	НовыйМассив = Новый Массив();
	НовыйМассив.Добавить(НоваяСвязь);
	НовыеСвязи = Новый ФиксированныйМассив(НовыйМассив);
	Элементы.Договор.СвязиПараметровВыбора = НовыеСвязи; 
	
КонецПроцедуры

&НаКлиенте
Процедура УстановкаВидимости()
	
	Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийРасходаДенег.ВыдачаПодотчётнику") 
		ИЛИ Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийРасходаДенег.ВыдачаЗаработнойПлаты")
		ИЛИ НЕ КонтрагентЯвляетсяКлиентом(Объект.Получатель) Тогда
		
		Элементы.Договор.Видимость = Ложь;	
	Иначе 
		Элементы.Договор.Видимость = Истина; 
	КонецЕсли;	
	
	Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийРасходаДенег.ВыдачаПодотчётнику") 
		ИЛИ Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийРасходаДенег.ВыдачаЗаработнойПлаты") Тогда
		СтрокаТипПлательщика = "СправочникСсылка.Сотрудники";	
	Иначе		
		СтрокаТипПлательщика = "СправочникСсылка.Контрагенты";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СтрокаТипПлательщика) Тогда         
		Массив = Новый Массив();
		Массив.Добавить(Тип(СтрокаТипПлательщика));    
		ОписаниеТипаПлательщика = Новый ОписаниеТипов(Массив);
		Элементы.Получатель.ОграничениеТипа = ОписаниеТипаПлательщика;        
	КонецЕсли;
	
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция КонтрагентЯвляетсяКлиентом(КонтрагентСсылка)  
	
	Запрос = Новый Запрос;  
	Запрос.УстановитьПараметр("КонтрагентСсылка", КонтрагентСсылка);
	Запрос.УстановитьПараметр("ТипыКонтрагентовКлиент", Перечисления.ТипыКонтрагентов.Клиент);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|    Контрагенты.Ссылка КАК Контрагент
	|ИЗ
	|    Справочник.Контрагенты КАК Контрагенты
	|ГДЕ
	|    Контрагенты.Ссылка = &КонтрагентСсылка
	|    И Контрагенты.ТипКонтрагента = &ТипыКонтрагентовКлиент";
	
	Результат = Запрос.Выполнить();
	
	Возврат Результат.Пустой();
	
КонецФункции

&НаКлиенте
Процедура ВидОперацииПриИзменении(Элемент)
	УстановкаВидимости();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановкаВидимости();
КонецПроцедуры

&НаКлиенте
Процедура ПолучательПриИзменении(Элемент)
	УстановкаВидимости();
КонецПроцедуры

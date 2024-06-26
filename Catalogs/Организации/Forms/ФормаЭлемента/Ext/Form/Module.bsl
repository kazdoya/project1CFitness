﻿
&НаКлиенте
Процедура ИзменениеВидимости()
	
	Если Объект.ТипОрганизации = ПредопределенноеЗначение("Перечисление.ТипыОрганизаций.ЮридическоеЛицо") Тогда
		Элементы.ГлавныйБухгалтер.Видимость = Истина;
	Иначе
		Элементы.ГлавныйБухгалтер.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Функция ПроверкаИНН(СтрокаСИНН)
	Если Объект.ТипОрганизации = ПредопределенноеЗначение("Перечисление.ТипыОрганизаций.ЮридическоеЛицо") 
		И СтрДлина(СтрокаСИНН) = 10 
		ИЛИ Объект.ТипОрганизации = ПредопределенноеЗначение("Перечисление.ТипыОрганизаций.ИндивидуальныйПредприниматель") 
		И СтрДлина(СтрокаСИНН) = 12 Тогда 
		Возврат Истина;
	Иначе
		Возврат Ложь;	
	КонецЕсли;
КонецФункции


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ИзменениеВидимости()
КонецПроцедуры


&НаКлиенте
Процедура ИННПриИзменении(Элемент)
	Если НЕ ПроверкаИНН(Объект.ИНН) Тогда 
		ОбщегоНазначенияКлиент.СообщитьПользователю("Ошибка. Длинна ИНН: ИП — 12 символов, для Юридического лица — 10", "Объект.ИНН");
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ТипОрганизацииПриИзменении(Элемент)
	ИзменениеВидимости();
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Если НЕ ПроверкаИНН(Объект.ИНН)	Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю("Ошибка. Длинна ИНН: ИП — 12 символов, для Юридического лица — 10", "Объект.ИНН");
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

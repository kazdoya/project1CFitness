﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Объект.Предопределенный Тогда
        Элементы.ФормулаРасчета.Доступность = Ложь;
    КонецЕсли;
КонецПроцедуры


//&НаКлиенте
//Процедура ПриОткрытии(Отказ)
//	Если Объект.Наименование = "Больничный"		
//		ИЛИ Объект.Наименование = "Оклад" Тогда
//		Элементы.ФормулаРасчета.Доступность = Ложь;
//	КонецЕсли;
//КонецПроцедуры


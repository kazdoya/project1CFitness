﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если НЕ ЗначениеЗаполнено(Объект.Ответственный) Тогда
		Объект.Ответственный = ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПересчетСуммыДокумента()
	Объект.СуммаДокумента = Объект.Услуги.Итог("Сумма") + Объект.Абонементы.Итог("Стоимость"); 
КонецПроцедуры

&НаКлиенте
Процедура УслугиКоличествоПриИзменении(Элемент)
	СТЧ = Элементы.Услуги.ТекущиеДанные;
	РаботаСТабличнымиЧастямиКлиент.ПересчитатьСуммуВСтрокеТЧ(СТЧ);
	ПересчетСуммыДокумента();
КонецПроцедуры

&НаКлиенте
Процедура УслугиЦенаПриИзменении(Элемент)
	СТЧ = Элементы.Услуги.ТекущиеДанные;
	РаботаСТабличнымиЧастямиКлиент.ПересчитатьСуммуВСтрокеТЧ(СТЧ);
	ПересчетСуммыДокумента();
КонецПроцедуры

&НаКлиенте
Процедура АбонементыАбонементПриИзменении(Элемент)
	СТЧ = Элементы.Абонементы.ТекущиеДанные;
	
	Если ЗначениеЗаполнено(СТЧ.Абонемент) Тогда
		СТЧ.Стоимость = РаботаСЦенамиСервер.ПолучитьЦенуПродажиНаДату(СТЧ.Абонемент, , Объект.Дата);
		СТЧ.КоличествоМесяцев = РаботаСНоменклатуройСервер.ПолучитьСрокДействияАбонементаПоНоменклатуре(СТЧ.Абонемент);
	Иначе
		СТЧ.Стоимость = 0;
		СТЧ.КоличествоМесяцев = 0;
	КонецЕсли;
	
	ПересчетСуммыДокумента();
КонецПроцедуры

&НаКлиенте
Процедура УслугиУслугаПриИзменении(Элемент)
	СТЧ = Элементы.Услуги.ТекущиеДанные;
	СТЧ.Количество = 1; 
	
	Если ЗначениеЗаполнено(СТЧ.Услуга) Тогда
		СТЧ.Цена = РаботаСЦенамиСервер.ПолучитьЦенуПродажиНаДату(СТЧ.Услуга, , Объект.Дата);
	Иначе
		СТЧ.Цена = 0;
	КонецЕсли;  
	
	РаботаСТабличнымиЧастямиКлиент.ПересчитатьСуммуВСтрокеТЧ(СТЧ);
	
	ПересчетСуммыДокумента();
	
КонецПроцедуры



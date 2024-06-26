﻿
&НаКлиенте
Процедура СкопироватьФайлНаСервер(СпособЗагрузки)
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения("СкопироватьФайлНаСерверЗавершение", ЭтотОбъект, СпособЗагрузки);
	НачатьПомещениеФайлаНаСервер(ОповещениеОЗавершении,,,,,УникальныйИдентификатор);
	
КонецПроцедуры  

&НаКлиенте
Процедура СкопироватьФайлНаСерверЗавершение(ОписаниеПомещенногоФайла, ДополнительныеПараметры) Экспорт
	
	Если ОписаниеПомещенногоФайла <> Неопределено Тогда
		
		АдресФайлаВХранилище = ОписаниеПомещенногоФайла.Адрес; 
		
		ЗагрузитьИзТабличногоДокументаНаСервере(АдресФайлаВХранилище, ДатаПрайсЛиста, ВидЦеныПродажи, ДополнительныеПараметры); 
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗагрузитьИзТабличногоДокументаНаСервере(АдресФайлаВХранилище, ДатаПрайсЛиста, ВидЦеныПродажи, ДополнительныеПараметры)
	
	ТабДок = ПрочитатьФайл(АдресФайлаВХранилище);
	Если ДополнительныеПараметры = "ТабличныйДокумент" Тогда
		ТаблицаПрайсЛиста = ЗаполнитьТаблицуЗначенийИзТабличногоДокумента(ТабДок);
	Конецесли;    
	
	Если ТаблицаПрайсЛиста.Количество() Тогда    
		ЗагрузитьПрайсЛистПоставщика(ТаблицаПрайсЛиста, ДатаПрайсЛиста, ВидЦеныПродажи); 
	Иначе
		СообщениеПользователю = Новый СообщениеПользователю();
		СообщениеПользователю.Текст = "Выбранный файл не содержит строк с ценами!";
		СообщениеПользователю.Сообщить();           
	КонецЕсли;    
	
КонецПроцедуры

&НаСервереБезКонтекста                            
Функция ПрочитатьФайл(АдресФайлаВХранилище)
	
	ТабДок = Новый ТабличныйДокумент;
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла(".xlsx"); 
	
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресФайлаВХранилище); 
	ДвоичныеДанные.Записать(ИмяВременногоФайла); 
	
	Попытка
		ТабДок.Прочитать(ИмяВременногоФайла); 
	Исключение  
		вызватьИсключение "Не удалось прочитать файл EXCEL в табличный документ!";
	КонецПопытки; 
	
	возврат ТабДок;
	
КонецФункции      

&НаСервереБезКонтекста
Функция ЗаполнитьТаблицуЗначенийИзТабличногоДокумента(ТабДок)
	
	ТаблицаПрайсЛиста = Новый ТаблицаЗначений; 
	
	ТаблицаПрайсЛиста.Колонки.Добавить("НомерСтроки", Новый ОписаниеТипов("Число"));;
	ТаблицаПрайсЛиста.Колонки.Добавить("Номенклатура",    Новый ОписаниеТипов("Строка", Новый КвалификаторыСтроки(100)));
	ТаблицаПрайсЛиста.Колонки.Добавить("Код",    Новый ОписаниеТипов("Строка", Новый КвалификаторыСтроки(9)));
	ТаблицаПрайсЛиста.Колонки.Добавить("Цена",    Новый ОписаниеТипов("Число"));;
	
	КоличествоСтрок = табДок.ВысотаТаблицы; 
	
	Для сч = 2 По КоличествоСтрок Цикл 
		
		СтрокаПрайса = ТаблицаПрайсЛиста.Добавить();
		
		Попытка 
			СтрокаПрайса.НомерСтроки    = Строка(ТабДок.ПолучитьОбласть("R" + Формат(сч, "ЧГ=0;") + "C1").ТекущаяОбласть.Текст);
			СтрокаПрайса.Номенклатура    = Строка(ТабДок.ПолучитьОбласть("R" + Формат(сч, "ЧГ=0;") + "C2").ТекущаяОбласть.Текст);
			СтрокаПрайса.Код    = Строка(ТабДок.ПолучитьОбласть("R" + Формат(сч, "ЧГ=0;") + "C3").ТекущаяОбласть.Текст); 
			СтрокаПрайса.Цена    = Число(ТабДок.ПолучитьОбласть("R" + Формат(сч, "ЧГ=0") + "C4").ТекущаяОбласть.Текст);
		Исключение
			вызватьИсключение "Не удалось прочитать файл EXCEL в табличный документ!";
		КонецПопытки;
		
	КонецЦикла;
	
	возврат ТаблицаПрайсЛиста;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ЗагрузитьПрайсЛистПоставщика(ТаблицаПрайсЛиста, ДатаПрайсЛиста, ВидЦеныПродажи)
	
	Запрос = Новый Запрос; 
	Запрос.УстановитьПараметр("ТаблицаПрайсЛиста", ТаблицаПрайсЛиста);
	
	Запрос.Текст=
	"ВЫБРАТЬ
	|	ТаблицаПрайсЛиста.НомерСтроки КАК НомерСтроки,
	|	ТаблицаПрайсЛиста.Номенклатура КАК Номенклатура,
	|	ТаблицаПрайсЛиста.Код КАК Код,
	|	ТаблицаПрайсЛиста.Цена КАК Цена
	|ПОМЕСТИТЬ ВТ_ТаблицаПрайсЛиста
	|ИЗ
	|	&ТаблицаПрайсЛиста КАК ТаблицаПрайсЛиста
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Ном.Ссылка КАК Номенклатура,
	|	ВТ_ТаблицаПрайсЛиста.Номенклатура КАК НоменклатураВТ,
	|	ВТ_ТаблицаПрайсЛиста.Код КАК Код,
	|	ВТ_ТаблицаПрайсЛиста.Цена КАК Цена
	|ИЗ
	|	ВТ_ТаблицаПрайсЛиста КАК ВТ_ТаблицаПрайсЛиста
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК Ном
	|		ПО ВТ_ТаблицаПрайсЛиста.Код = Ном.Код";
	
	Рез = Запрос.Выполнить();
	Если Рез.Пустой() Тогда
		возврат;
	КонецЕсли;
	
	Выборка = Рез.Выбрать();
	
	НаборЗаписей = РегистрыСведений.ЦеныНоменклатуры.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Период.Установить(ДатаПрайсЛиста);
	
	КоличествоЗаписей = 0;
	
	Пока Выборка.Следующий() Цикл
		НоваяЗапись = НаборЗаписей.Добавить();
		НоваяЗапись.Период = ДатаПрайсЛиста;
		НоваяЗапись.Номенклатура = Выборка.Номенклатура;
		НоваяЗапись.ВидЦены = ВидЦеныПродажи;
		НоваяЗапись.Сумма = Выборка.Цена;
		КоличествоЗаписей = КоличествоЗаписей + 1;	
	КонецЦикла;
		
	Попытка
		
		НаборЗаписей.Записать(); 
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = СтрШаблон("В регистр загружено строк: %1!", КоличествоЗаписей);
		Сообщение.Сообщить();
		
	Исключение 
		
		СообщениеПользователю = Новый СообщениеПользователю();
		СообщениеПользователю.Текст = "Произошла ошибка при записи цен в регистр!";
		СообщениеПользователю.Сообщить();
		
	КонецПопытки;
	
Конецпроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ДатаПрайсЛиста = ТекущаяДата();
	ВидЦеныПродажи = ПредопределенноеЗначение("Перечисление.ВидыЦенПродажи.Розничная");
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьПрайс(Команда)
	СкопироватьФайлНаСервер("ТабличныйДокумент");
КонецПроцедуры

﻿
&НаКлиенте
Процедура НомерБланкаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	Элементы.НомерБланка.СписокВыбора.ЗагрузитьЗначения(ЭкспертизаИСертификация.ВернутьСписокНомеровБланков(ВидСертификата,Организация,Эксперт));
	
	
	
	
КонецПроцедуры

&НаКлиенте
Процедура НомерБланкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
		Элементы.НомерБланка.СписокВыбора.ЗагрузитьЗначения(ЭкспертизаИСертификация.ВернутьСписокНомеровБланков(ВидСертификата,Организация,Эксперт));
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	если параметры.ДанныеСертификата.ПолныйНомер="" тогда Отказ=истина; конецесли;

	
	ЗаполнитьЗначенияСвойств(этаформа,параметры.ДанныеСертификата);	
	
	ЭкспертизаИСертификация.ЗаполнитьТЧИзМассиваСтруктур(тнвед,параметры.ТаблицаСертификата,Неопределено);
	
	СтруктураДанныхСертификатов = Новый Структура();
	
	Для каждого Элемент Из параметры.ДанныеСертификата Цикл
		СтруктураДанныхСертификатов.Вставить(Элемент.Ключ);
	КонецЦикла;
	
	
	
	Если ОтправленВТТПРФ Тогда    ЭтаФорма.Доступность=ложь;  	КонецЕсли;
	Если Статус=Перечисления.СтатусыСертификатов._9  Тогда    ЭтаФорма.Доступность=ложь;  	КонецЕсли;
	
	
	
	///////////////////////////////////////////Параметры формы сертификата////////////////////////////////////
	
	Если не ЗначениеЗаполнено(Статус) тогда
		статус=Перечисления.СтатусыСертификатов._6;
		
	КонецЕсли;
	
	РеквизитПодбораТНВЕД="НаименованиеРусское";
	
	Элементы.КнопкаТНВЕДПодбор.Видимость=истина;
	
	Если   НомерБланка>0   тогда
		
		Элементы.НомерБланка.СписокВыбора.Добавить(НомерБланка);
		//Элементы.НомерБланка.Доступность=не ЭкспертизаСертификацияПИ.ПолучитьЗапретНаСменуНомеровБланковПослеВыбора();
	КонецЕсли;
	
	Если Статус<>Перечисления.СтатусыСертификатов._6  Тогда 
	элементы.НомерБланка.Доступность=ложь;
	иначе
	элементы.НомерБланка.Доступность=истина;
	конецесли;
	
	если не значениезаполнено(Подписант) Тогда
	Подписант=справочники.Пользователи.НайтиПоНаименованию("Смоленко И");
    конецесли;
	
	
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	
	
	ЗаполнитьЗначенияСвойств(СтруктураДанныхСертификатов,Этаформа)  ;
	ЭтаФорма.Закрыть(новый структура("Команда,ДанныеСертификата,Таблица","ок",СтруктураДанныхСертификатов,ЭкспертизаИСертификация.ТЧВМасивструктур(тнвед)));
	
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	ЭтаФорма.Закрыть(новый структура("Команда","отмена"));
КонецПроцедуры

&НаКлиенте
Процедура ТНВЕДПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	макстр=0;
	для каждого сттнв из ТНВЕД цикл
		если   сттнв.НомерСтрок=0 тогда продолжить;КонецЕсли;
		макстр=макс(макстр,сттнв.НомерСтрок);
	конеццикла;
	
	Если НоваяСтрока тогда
		//Элемент.ТекущиеДанные.НомерСтрок=Элемент.ТекущаяСтрока+1 ;
		Элемент.ТекущиеДанные.НомерСтрок=макстр+1 ;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТНВЕДПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	
	элемент.ТекущиеДанные.ид=ид;	
КонецПроцедуры


&НаКлиенте
Процедура Подбор(Команда)
	ЗначениеОтбора = Новый Структура();
	//   ЗначениеОтбора.Вставить("Организация", Организация);
	ПараметрыВыбора = Новый Структура("ЗакрыватьПриВыборе, МножественныйВыбор, Отбор", Истина, Истина, ЗначениеОтбора);
	
	Оповещение = новый ОписаниеОповещения("ОбработатьПодборТнвед",ЭтаФорма);
	
	ОткрытьФорму("Справочник.КлассификаторТНВЭД.ФормаВыбора",ПараметрыВыбора,ЭтаФорма,,,,Оповещение);  //
	
КонецПроцедуры


&НаКлиенте
Процедура ОбработатьПодборТнвед(Рез,ДопПараметры) Экспорт
	Если рез=Неопределено тогда
		возврат;
	конецесли;
	для каждого ии из рез цикл
		стр=тнвед.Добавить();
		стр.ид=ид;
		стр.товар=ЭкспертизаИСертификация.ЗначениеРеквизитаОбъекта(ии,РеквизитПодбораТНВЕД);
		
	конеццикла;
	
	
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	//Вставить содержимое обработчика
КонецПроцедуры
&НаКлиенте
Функция УС(тхт)      // убратьсимволы
	Возврат(сокрлп(стрзаменить(тхт,Символ(7),""))) ;
КонецФункции


&НаКлиенте
Процедура Загрузить(Команда)
	
	
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	// Задаем фильтр доступных расширений файлов для выбора
	Диалог.Фильтр = "Документ Еxel |*.xls;*.xlsx";
	
	Диалог.Заголовок = НСтр("ru=’Выберите файл шаблона для загрузки'");
	// Создаем объект ОписаниеОповещения, который будет передан в метод Показать
	ОповещениеЗавершения = Новый ОписаниеОповещения("ВыборФайлаЗавершение", ЭтотОбъект);
	// Открываем окно выбора файла
	Диалог.Показать(ОповещениеЗавершения);
	
	
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборФайлаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПутьКФайлу = Результат[0];
	ЗагрузитьизДокумента(ПутьКФайлу) ;
КонецПроцедуры



&НаКлиенте
Процедура ЗагрузитьизДокумента(имяфайла)
	
	Попытка
		
		
		ПриложениеExcel = Новый COMОбъект("Excel.Application"); 
		
		
		
	ФайлExcel = ПриложениеExcel.WorkBooks.Open(имяфайла);   
 
	//Отключаем отображение всех предупреждений    
	ФайлExcel.Application.DisplayAlerts = False;   
 
	//Выбираем первый лист книги Excel для работы  
	ЛистExcel = ФайлExcel.Sheets(1);               
 
		
		
	Исключение
		
		ПоказатьПредупреждение(Неопределено, "При открытия Excel Application произошла ошибка. Проверти правильность установки",10,"Ошибка загрузки шаблона");
		
		Возврат;
	КонецПопытки;
	
	
	
	// перебирая строки выводим текст 
	//
	таб1=ЛистExcel;
	//таб2=Документ.Content.Tables(2);
	//таб3=Документ.Content.Tables(3);
	
	
	//Документ.Content.Tables(1).Cell(1, 1).Range.Text
	
	Отправитель=УС(таб1.Cells(2,1).Value);
	
	//Экспортер=
	Получатель=УС(таб1.Cells(6,1).Value);
	//Страназап = УС(таб1.Cells(6,2).Value);
	//
	//страназап=ЭкспертизаИСертификация.НайтиСтранупоИмени(Страназап);
	//Если ЗначениеЗаполнено(Страназап) тогда
	//	Страна=Страназап;
	//КонецЕсли;
	
	
	//Импортер=
	Маршрут=УС(таб1.Cells(8,1).Value) ;
	
	масивстрок=   СтрРазделить(Маршрут,Символы.ВК);
	
	
	СлужебнаяОтметка=УС(таб1.Cells(8,4).Value);
	Транспорт="";
	
	
	тнвед.Очистить();
	
	для  ии=10   по 25 цикл
		
		знч1=УС(таб1.Cells(ии,3).Value) ;
		
		если не ПустаяСтрока(знч1) тогда
			стр=тнвед.Добавить();
			
			стр.номерстрок=  сокрлп(стрзаменить(стрзаменить(таб1.Cells(ии,1).Value,Символ(7),""),".",""));
			стр.мест= УС(таб1.Cells(ии,2).Value)    ;
			стр.товар=знч1    ;
		//	стр.КритерийПроисхождения=УС(таб1.Cell(ии,4).Range.Text)    ;
			стр.вес=УС(таб1.Cells(ии,5).Value)    ;
			стр.ид=ид;
			если ии=10 тогда
				Счетфактура=УС(таб1.Cells(ии,6).Value) ;
			КонецЕсли;
			
		иначе
			//Прервать;
			
		КонецЕсли;
		
		
	конеццикла   ;
	
	странас=УС(таб1.Cells(28,4).Value)   ;
	
	ПодписантКонтрагента=УС(таб1.Cells(30,4).Value)    ;
	
	ДатаДекларации=сокрлп(стрзаменить(УС(таб1.Cells(31,4).Value),"г.",""))  +" 12:00:00"   ;
	
	
	
	
	
	
	
	
	
	
	
	
	ПриложениеExcel.Quit(); 
КонецПроцедуры


&НаСервере
Процедура УстановитьСтусПроектНаСервере()

статус=Перечисления.СтатусыСертификатов._6;
	
КонецПроцедуры
	
&НаКлиенте
Процедура СтатусПриИзменении(Элемент)
	
	если Элемент.ТекстРедактирования<>"6   - проект"  тогда
	элементы.НомерБланка.Доступность=ложь;
	иначе
	элементы.НомерБланка.Доступность=истина;
	конецесли;
	
	 если Элемент.ТекстРедактирования="9   - аннулирован"  тогда
     УстановитьСтусПроектНаСервере();
     конецесли;
	 
	Если   НомерБланка=0   тогда
	УстановитьСтусПроектНаСервере();
	КонецЕсли;
	 
	 
КонецПроцедуры


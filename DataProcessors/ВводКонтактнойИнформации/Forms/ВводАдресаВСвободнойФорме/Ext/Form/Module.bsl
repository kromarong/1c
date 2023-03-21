﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

// Форма параметризуется:
//
//      Заголовок     - Строка  - заголовок формы.
//      ЗначенияПолей - Строка  - сериализованное значение контактной информации или пустая строка для 
//                                ввода нового.
//      Представление - Строка  - представление адреса (используется только при работе со старыми данными).
//      ВидКонтактнойИнформации - СправочникСсылка.ВидыКонтактнойИнформации, Структура - описание того, что мы
//                                редактируем.
//      Комментарий  - Строка   - необязательный комментарий, для подстановки в поле "Комментарий".
//
//      ВозвращатьСписокЗначений - Булево - необязательный флаг того, что возвращаемое значение поля.
//                                 КонтактнаяИнформация будет иметь тип СписокЗначений (совместимость).
//
//  Результат выбора:
//      Структура - поля:
//          * КонтактнаяИнформация   - Строка - XML контактной информации.
//          * Представление          - Строка - Представление.
//          * Комментарий            - Строка - Комментарий.
//          * ВведеноВСвободнойФорме - Булево - флаг ввода.
//

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не Параметры.Свойство("ОткрытаПоСценарию") Тогда
		ВызватьИсключение НСтр("ru = 'Обработка не предназначена для непосредственного использования.'");
	КонецЕсли;
	
	// Настройки формы
	Параметры.Свойство("ВозвращатьСписокЗначений", ВозвращатьСписокЗначений);
	
	ОсновнаяСтрана           = ОсновнаяСтрана();
	ВидКонтактнойИнформации  = УправлениеКонтактнойИнформациейСлужебный.СтруктураВидаКонтактнойИнформации(Параметры.ВидКонтактнойИнформации);
	ПриСозданииНаСервереХранитьИсториюИзменений();
	
	Заголовок = ?(ПустаяСтрока(Параметры.Заголовок), ВидКонтактнойИнформации.Наименование, Параметры.Заголовок);
	
	СкрыватьНеактуальныеАдреса  = ВидКонтактнойИнформации.СкрыватьНеактуальныеАдреса;
	ТипКонтактнойИнформации     = ВидКонтактнойИнформации.Тип;
	
	// Пытаемся заполнить из параметров.
	ЗначенияПолей = ОпределитьЗначениеАдреса(Параметры);
	
	Если ПустаяСтрока(ЗначенияПолей) Тогда
		НаселенныйПунктДетально = УправлениеКонтактнойИнформацией.ОписаниеНовойКонтактнойИнформации(Перечисления.ТипыКонтактнойИнформации.Адрес); // Новый адрес
		НаселенныйПунктДетально.AddressType = УправлениеКонтактнойИнформациейКлиентСервер.АдресВСвободнойФорме();
	ИначеЕсли УправлениеКонтактнойИнформациейКлиентСервер.ЭтоКонтактнаяИнформацияВJSON(ЗначенияПолей) Тогда
		ДанныеАдреса = УправлениеКонтактнойИнформациейСлужебный.JSONВКонтактнуюИнформациюПоПолям(ЗначенияПолей, Перечисления.ТипыКонтактнойИнформации.Адрес);
		НаселенныйПунктДетально = ПодготовитьАдресДляВвода(ДанныеАдреса);
	Иначе
		XDTOКонтактная = ИзвлечьСтарыйФорматАдреса(ЗначенияПолей, ТипКонтактнойИнформации);
		ДанныеАдреса = УправлениеКонтактнойИнформациейСлужебный.КонтактнаяИнформацияВСтруктуруJSON(XDTOКонтактная, ТипКонтактнойИнформации);
		НаселенныйПунктДетально = ПодготовитьАдресДляВвода(ДанныеАдреса);
	КонецЕсли;
	
	УстановитьЗначениеРеквизитовПоКонтактнойИнформации(ЭтотОбъект, НаселенныйПунктДетально);
	
	Если ЗначениеЗаполнено(НаселенныйПунктДетально.Comment) Тогда
		Элементы.ОсновныеСтраницы.ОтображениеСтраниц = ОтображениеСтраницФормы.ЗакладкиСверху;
		Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Комментарий);
	Иначе
		Элементы.ОсновныеСтраницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	КонецЕсли;
	
	УстановитьКлючИспользованияФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЗначениеЗаполнено(ТекстПредупрежденияПриОткрытии) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстПредупрежденияПриОткрытии,, ПолеПредупрежденияПриОткрытии);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ПодтвердитьИЗакрыть", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтранаПриИзменении(Элемент)
	
	ОтобразитьПоляПоТипуАдреса();
	
КонецПроцедуры

&НаКлиенте
Процедура СтранаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура СтранаАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	Если Ожидание = 0 Тогда
		// Формирование списка быстрого выбора.
		Если ПустаяСтрока(Текст) Тогда
			ДанныеВыбора = Новый СписокЗначений;
		КонецЕсли;
		Возврат;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СтранаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ПустаяСтрока(Текст) Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
#Если ВебКлиент Тогда
	// Обход особенности платформы.
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора         = Новый СписокЗначений;
	ДанныеВыбора.Добавить(Страна);
#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура СтранаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	УправлениеКонтактнойИнформациейКлиент.СтранаМираОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры


&НаКлиенте
Процедура КомментарийПриИзменении(Элемент)
	
	НаселенныйПунктДетально.Comment = Комментарий;
	ПодключитьОбработчикОжидания("УстановитьПиктограммуКомментария", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеИностранногоАдресаПриИзменении(Элемент)
	
	НаселенныйПунктДетально.street = ПредставлениеАдреса;
	НаселенныйПунктДетально.AddressType = УправлениеКонтактнойИнформациейКлиентСервер.АдресВСвободнойФорме();
	НаселенныйПунктДетально.Comment = Комментарий;
	НаселенныйПунктДетально.Country = Строка(Страна);
	
КонецПроцедуры

// Дом, помещения

&НаКлиенте
Процедура АдресНаДатуАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	Если СтрСравнить(Текст, НСтр("ru='начало учета'")) = 0 Или ПустаяСтрока(Текст) Тогда
		Элементы.АдресНаДату.ФорматРедактирования = "";
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура АдресНаДатуПриИзменении(Элемент)
	
	Если Не ВводНовогоАдреса Тогда
		
		Отбор = Новый Структура("Вид", ВидКонтактнойИнформации.Ссылка);
		НайденныеСтроки = КонтактнаяИнформацияОписаниеДополнительныхРеквизитов.НайтиСтроки(Отбор);
		Результат = ОпределитьДатуДействия(АдресНаДату, НайденныеСтроки);
		
		Если Результат.ТекущаяСтрока <> Неопределено Тогда
			Тип = Результат.ТекущаяСтрока.Тип;
			АдресДействуетС = Результат.ДействуетС;
			НаселенныйПунктДетально = АдресСИсторией(Результат.ТекущаяСтрока.Значение);
		Иначе
			Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Адрес");
			АдресДействуетС = АдресНаДату;
			НаселенныйПунктДетально = УправлениеКонтактнойИнформациейКлиентСервер.ОписаниеНовойКонтактнойИнформации(Тип);
		КонецЕсли;
		
		
		
		Если ЗначениеЗаполнено(Результат.ДействуетПо) Тогда
			ТекстИсторическийАдрес = " " + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'действует по %1'"), Формат(Результат.ДействуетПо - 10, "ДЛФ=DD"));
		Иначе
			ТекстИсторическийАдрес = НСтр("ru = 'действует по настоящее время.'");
		КонецЕсли;
		Элементы.ТекстПроДатуДействия.Заголовок = ТекстИсторическийАдрес;
	Иначе
		АдресДействуетС = АдресНаДату;
	КонецЕсли;
	
	ТекстНачалаУчета = НСтр("ru = 'начало учета'");
	Элементы.АдресНаДату.ФорматРедактирования = ?(ЗначениеЗаполнено(АдресНаДату), "", "ДФ='""" + ТекстНачалаУчета  + """'");
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция АдресСИсторией(ЗначенияПолей)
	
	Возврат УправлениеКонтактнойИнформациейСлужебный.JSONВКонтактнуюИнформациюПоПолям(ЗначенияПолей, Перечисления.ТипыКонтактнойИнформации.Адрес);
	
КонецФункции

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	ПодтвердитьИЗакрыть();
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	Модифицированность = Ложь;
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьАдрес(Команда)
	
	ОчиститьАдресКлиент();
	
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияИзменений(Команда)
	
	ДополнительныеПараметры = Новый Структура;
	
	ОписаниеДополнительныхРеквизитов = КонтактнаяИнформацияОписаниеДополнительныхРеквизитов;
	СписокКонтактнойИнформации = ЗаполнитьСписокКонтактнойИнформации(ВидКонтактнойИнформации.Ссылка, ОписаниеДополнительныхРеквизитов);
	
	ПараметрыФормы = Новый Структура("СписокКонтактнойИнформации", СписокКонтактнойИнформации);
	ПараметрыФормы.Вставить("ВидКонтактнойИнформации", ВидКонтактнойИнформации.Ссылка);
	ПараметрыФормы.Вставить("ТолькоПросмотр", ЭтотОбъект.ТолькоПросмотр);
	ПараметрыФормы.Вставить("ИзФормыВводаАдреса", Истина);
	ПараметрыФормы.Вставить("ДействуетС", АдресНаДату);
	
	ОповещениеОЗакрытие = Новый ОписаниеОповещения("ПослеЗакрытияФормыИстории", ЭтотОбъект, ДополнительныеПараметры);
	ОткрытьФорму("Обработка.ВводКонтактнойИнформации.Форма.ИсторияКонтактнойИнформации", ПараметрыФормы, ЭтотОбъект,,,, ОповещениеОЗакрытие);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьКомментарий(Команда)
	Элементы.ОсновныеСтраницы.ОтображениеСтраниц = ОтображениеСтраницФормы.ЗакладкиСверху;
	Элементы.ОсновныеСтраницы.ТекущаяСтраница = Элементы.СтраницаКомментарий;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьПиктограммуКомментария()
	Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Комментарий);
КонецПроцедуры

&НаКлиенте
Процедура ПодтвердитьИЗакрыть(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если Модифицированность Тогда // При немодифицированности работает как "отмена".
		Контекст = Новый Структура("ВидКонтактнойИнформации, НаселенныйПунктДетально, ОсновнаяСтрана, Страна");
		ЗаполнитьЗначенияСвойств(Контекст, ЭтотОбъект);
		Результат = РезультатаВыбораПоОбновлениюФлагов(Контекст, ВозвращатьСписокЗначений);
		
		// Флаги вида были прочитаны заново.
		ВидКонтактнойИнформации = Контекст.ВидКонтактнойИнформации;
		
		Результат = Результат.ДанныеВыбора;
		Если ВидКонтактнойИнформации.ХранитьИсториюИзменений Тогда
			ОбработатьКонтактнуюИнформациюСИсторией(Результат);
		КонецЕсли;
		
		Если ТипЗнч(Результат) = Тип("Структура") Тогда
			Результат.Вставить("КонтактнаяИнформацияОписаниеДополнительныхРеквизитов", КонтактнаяИнформацияОписаниеДополнительныхРеквизитов);
		КонецЕсли;
		
		СброситьМодифицированностьПриВыборе();
#Если ВебКлиент Тогда
		ФлагЗакрытия = ЗакрыватьПриВыборе;
		ЗакрыватьПриВыборе = Ложь;
		ОповеститьОВыборе(Результат);
		ЗакрыватьПриВыборе = ФлагЗакрытия;
#Иначе
		ОповеститьОВыборе(Результат);
#КонецЕсли
		СохранитьСостояниеФормы();
		
	ИначеЕсли Комментарий <> КопияКомментария Тогда
		// Изменен только комментарий, пробуем вернуть обновленное.
		Результат = РезультатВыбораТолькоКомментария(Параметры.ЗначенияПолей, Параметры.Представление, Комментарий);
		Результат = Результат.ДанныеВыбора;
		
		СброситьМодифицированностьПриВыборе();
#Если ВебКлиент Тогда
		ФлагЗакрытия = ЗакрыватьПриВыборе;
		ЗакрыватьПриВыборе = Ложь;
		ОповеститьОВыборе(Результат);
		ЗакрыватьПриВыборе = ФлагЗакрытия;
#Иначе
		ОповеститьОВыборе(Результат);
#КонецЕсли
		СохранитьСостояниеФормы();
		
	Иначе
		Результат = Неопределено;
	КонецЕсли;
	
	Если (МодальныйРежим Или ЗакрыватьПриВыборе) И Открыта() Тогда
		СброситьМодифицированностьПриВыборе();
		СохранитьСостояниеФормы();
		Закрыть(Результат);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработатьКонтактнуюИнформациюСИсторией(Результат)
	
	Результат.Вставить("ДействуетС", ?(ВводНовогоАдреса, АдресНаДату, АдресДействуетС));
	ИмяРеквизита = "";
	Отбор = Новый Структура("Вид", Результат.Вид);
	
	СтрокаДействующегоАдреса = Неопределено;
	ДатаБылаИзменена         = Истина;
	ТекущаяДатаАдреса        = ОбщегоНазначенияКлиент.ДатаСеанса();
	Дельта                   = АдресНаДату - ТекущаяДатаАдреса;
	МинимальнаяДельта        = ?(Дельта > 0, Дельта, -Дельта);
	НайденныеСтроки          = КонтактнаяИнформацияОписаниеДополнительныхРеквизитов.НайтиСтроки(Отбор);
	Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
		Если ЗначениеЗаполнено(НайденнаяСтрока.ИмяРеквизита) Тогда
			ИмяРеквизита = НайденнаяСтрока.ИмяРеквизита;
		КонецЕсли;
		Если НайденнаяСтрока.ДействуетС = АдресНаДату Тогда
			ДатаБылаИзменена = Ложь;
			СтрокаДействующегоАдреса = НайденнаяСтрока;
			Прервать;
		КонецЕсли;
		
		Дельта = ТекущаяДатаАдреса - НайденнаяСтрока.ДействуетС;
		Дельта = ?(Дельта > 0, Дельта, -Дельта);
		Если Дельта <= МинимальнаяДельта Тогда
			МинимальнаяДельта = Дельта;
			СтрокаДействующегоАдреса = НайденнаяСтрока;
		КонецЕсли;
	КонецЦикла;
	
	Если ДатаБылаИзменена Тогда
		
		Отбор = Новый Структура("ДействуетС, Вид", АдресДействуетС, Результат.Вид);
		СтрокиСАдресом = КонтактнаяИнформацияОписаниеДополнительныхРеквизитов.НайтиСтроки(Отбор);
		
		ПредставлениеРедактируемогоАдреса = ?(СтрокиСАдресом.Количество() > 0, СтрокиСАдресом[0].Представление, "");
		Если СтрСравнить(Результат.Представление, ПредставлениеРедактируемогоАдреса) <> 0 Тогда
			НоваяКонтактнаяИнформация = КонтактнаяИнформацияОписаниеДополнительныхРеквизитов.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяКонтактнаяИнформация, Результат);
			НоваяКонтактнаяИнформация.ЗначенияПолей           = Результат.КонтактнаяИнформация;
			НоваяКонтактнаяИнформация.Значение                = Результат.Значение;
			НоваяКонтактнаяИнформация.ДействуетС              = АдресНаДату;
			НоваяКонтактнаяИнформация.ХранитьИсториюИзменений = Истина;
			Если СтрокаДействующегоАдреса = Неопределено Тогда
				Отбор = Новый Структура("ЭтоИсторическаяКонтактнаяИнформация, Вид", Ложь, Результат.Вид);
				НайденныеСтроки = КонтактнаяИнформацияОписаниеДополнительныхРеквизитов.НайтиСтроки(Отбор);
				Для каждого НайденнаяСтрока Из НайденныеСтроки Цикл
					НайденнаяСтрока.ЭтоИсторическаяКонтактнаяИнформация = Истина;
					НайденнаяСтрока.ИмяРеквизита = "";
				КонецЦикла;
				НоваяКонтактнаяИнформация.ИмяРеквизита = ИмяРеквизита;
				НоваяКонтактнаяИнформация.ЭтоИсторическаяКонтактнаяИнформация = Ложь;
			Иначе
				НоваяКонтактнаяИнформация.ЭтоИсторическаяКонтактнаяИнформация = Истина;
				Результат.Представление                = СтрокаДействующегоАдреса.Представление;
				Результат.КонтактнаяИнформация         = СтрокаДействующегоАдреса.ЗначенияПолей;
				Результат.Значение = СтрокаДействующегоАдреса.Значение;
			КонецЕсли;
		ИначеЕсли СтрСравнить(Результат.Комментарий, СтрокаДействующегоАдреса.Комментарий) <> 0 И СтрокиСАдресом.Количество() > 0 Тогда
			// Поменяли только комментарий.
			СтрокиСАдресом[0].Комментарий = Результат.Комментарий;
		КонецЕсли;
	Иначе
		Если СтрСравнить(Результат.Представление, СтрокаДействующегоАдреса.Представление) <> 0
			ИЛИ СтрСравнить(Результат.Комментарий, СтрокаДействующегоАдреса.Комментарий) <> 0 Тогда
				ЗаполнитьЗначенияСвойств(СтрокаДействующегоАдреса, Результат);
				СтрокаДействующегоАдреса.ЗначенияПолей                       = Результат.КонтактнаяИнформация;
				СтрокаДействующегоАдреса.Значение                            = Результат.Значение;
				СтрокаДействующегоАдреса.ИмяРеквизита                        = ИмяРеквизита;
				СтрокаДействующегоАдреса.ЭтоИсторическаяКонтактнаяИнформация = Ложь;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияФормыИстории(Результат, ДополнительныеПараметры) Экспорт

	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВводНовогоАдреса = ?(Результат.Свойство("ВводНовогоАдреса"), Результат.ВводНовогоАдреса, Ложь);
	Если ВводНовогоАдреса Тогда
		АдресДействуетС = АдресНаДату;
		АдресНаДату = Результат.ТекущийАдрес;
		НаселенныйПунктДетально = УправлениеКонтактнойИнформациейКлиентСервер.ОписаниеНовойКонтактнойИнформации(ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Адрес"));
	Иначе
		Отбор = Новый Структура("Вид", ВидКонтактнойИнформации.Ссылка);
		НайденныеСтроки = КонтактнаяИнформацияОписаниеДополнительныхРеквизитов.НайтиСтроки(Отбор);
		
		ИмяРеквизита = "";
		Для Каждого СтрокаКонтактнойИнформации Из НайденныеСтроки Цикл
			Если НЕ СтрокаКонтактнойИнформации.ЭтоИсторическаяКонтактнаяИнформация Тогда
				ИмяРеквизита = СтрокаКонтактнойИнформации.ИмяРеквизита;
			КонецЕсли;
			КонтактнаяИнформацияОписаниеДополнительныхРеквизитов.Удалить(СтрокаКонтактнойИнформации);
		КонецЦикла;
		
		Для Каждого СтрокаКонтактнойИнформации Из Результат.История Цикл
			ДанныеСтроки = КонтактнаяИнформацияОписаниеДополнительныхРеквизитов.Добавить();
			ЗаполнитьЗначенияСвойств(ДанныеСтроки, СтрокаКонтактнойИнформации);
			Если НЕ СтрокаКонтактнойИнформации.ЭтоИсторическаяКонтактнаяИнформация Тогда
				ДанныеСтроки.ИмяРеквизита = ИмяРеквизита;
			КонецЕсли;
			Если НачалоДня(Результат.ТекущийАдрес) = НачалоДня(СтрокаКонтактнойИнформации.ДействуетС) Тогда
				АдресНаДату = Результат.ТекущийАдрес;
				НаселенныйПунктДетально = СтрокаJSONВСтруктуру(СтрокаКонтактнойИнформации.Значение);
				
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	ОтобразитьИнформациюОДатахДействияАдреса(АдресНаДату);
	
	Если НЕ ЭтотОбъект.Модифицированность Тогда
		ЭтотОбъект.Модифицированность = Результат.Модифицированность;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СтрокаJSONВСтруктуру(Значение)
	Возврат УправлениеКонтактнойИнформациейСлужебный.JSONВКонтактнуюИнформациюПоПолям(Значение, Перечисления.ТипыКонтактнойИнформации.Адрес);
КонецФункции

&НаКлиенте
Процедура СохранитьСостояниеФормы()
	УстановитьКлючИспользованияФормы();
	СохраняемыеВНастройкахДанныеМодифицированы = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СброситьМодифицированностьПриВыборе()
	Модифицированность = Ложь;
	КопияКомментария   = Комментарий;
КонецПроцедуры

&НаСервереБезКонтекста
Функция РезультатаВыбораПоОбновлениюФлагов(Контекст, ВозвращатьСписокЗначений = Ложь)
	// Обновляем некоторые флаги
	ЗначениеФлагов = УправлениеКонтактнойИнформациейСлужебный.СтруктураВидаКонтактнойИнформации(Контекст.ВидКонтактнойИнформации.Ссылка);
	
	Контекст.ВидКонтактнойИнформации.ТолькоНациональныйАдрес = ЗначениеФлагов.ТолькоНациональныйАдрес;
	Контекст.ВидКонтактнойИнформации.ПроверятьКорректность   = ЗначениеФлагов.ПроверятьКорректность;

	Возврат РезультатВыбора(Контекст, ВозвращатьСписокЗначений);
КонецФункции

&НаСервереБезКонтекста
Функция РезультатВыбора(Контекст, ВозвращатьСписокЗначений = Ложь)

	НаселенныйПунктДетально = Контекст.НаселенныйПунктДетально;
	Результат      = Новый Структура("ДанныеВыбора, ОшибкиЗаполнения");
	
	Если Контекст.ВидКонтактнойИнформации.ВключатьСтрануВПредставление И ЗначениеЗаполнено(НаселенныйПунктДетально.country) Тогда
		НаселенныйПунктДетально.Value = НаселенныйПунктДетально.country + ", " + НаселенныйПунктДетально.street;
	Иначе
		НаселенныйПунктДетально.Value = НаселенныйПунктДетально.street;
	КонецЕсли;
	
	Результат.ДанныеВыбора = Новый Структура;
	Результат.ДанныеВыбора.Вставить("Представление", НаселенныйПунктДетально.Value);
	Результат.ДанныеВыбора.Вставить("КонтактнаяИнформация", 
		УправлениеКонтактнойИнформациейСлужебный.КонтактнаяИнформацияИзJSONВXML(НаселенныйПунктДетально, Контекст.ВидКонтактнойИнформации.Тип));
	Результат.ДанныеВыбора.Вставить("Значение", УправлениеКонтактнойИнформациейСлужебный.СтруктураВСтрокуJSON(НаселенныйПунктДетально));
	Результат.ДанныеВыбора.Вставить("Комментарий", НаселенныйПунктДетально.Comment);
	Результат.ДанныеВыбора.Вставить("ВведеноВСвободнойФорме",
		УправлениеКонтактнойИнформациейСлужебный.АдресВведенВСвободнойФорме(НаселенныйПунктДетально));
	
	// ошибки заполнения
	Результат.ОшибкиЗаполнения = Новый Массив;
		
	Если Контекст.ВидКонтактнойИнформации.Тип = Перечисления.ТипыКонтактнойИнформации.Адрес 
		И Контекст.ВидКонтактнойИнформации.ВидРедактирования = "Диалог" Тогда
			АдресВВидеГиперссылки = Истина;
	Иначе
			АдресВВидеГиперссылки = Ложь;
	КонецЕсли;
	Результат.ДанныеВыбора.Вставить("АдресВВидеГиперссылки", АдресВВидеГиперссылки);
	
	// Подавляем перенос строк в возвращаемом отдельно представлении.
	Результат.ДанныеВыбора.Представление = СокрЛП(СтрЗаменить(Результат.ДанныеВыбора.Представление, Символы.ПС, " "));
	Результат.ДанныеВыбора.Вставить("Вид", Контекст.ВидКонтактнойИнформации.Ссылка);
	Результат.ДанныеВыбора.Вставить("Тип", Контекст.ВидКонтактнойИнформации.Тип);
	
	Возврат Результат;
КонецФункции

&НаСервереБезКонтекста
Функция ЗаполнитьСписокКонтактнойИнформации(ВидКонтактнойИнформации, КонтактнаяИнформацияОписаниеДополнительныхРеквизитов)

	Отбор = Новый Структура("Вид", ВидКонтактнойИнформации);
	НайденныеСтроки = КонтактнаяИнформацияОписаниеДополнительныхРеквизитов.НайтиСтроки(Отбор);
	
	СписокКонтактнойИнформации = Новый Массив;
	Для каждого СтрокаКонтактнойИнформации Из НайденныеСтроки Цикл
		КонтактнаяИнформация = Новый Структура("Представление, Значение, ЗначенияПолей, ДействуетС, Комментарий");
		ЗаполнитьЗначенияСвойств(КонтактнаяИнформация, СтрокаКонтактнойИнформации);
		СписокКонтактнойИнформации.Добавить(КонтактнаяИнформация);
	КонецЦикла;
	
	Возврат СписокКонтактнойИнформации;
КонецФункции

&НаСервере
Функция РезультатВыбораТолькоКомментария(КонтактнаяИнфо, Представление, Комментарий)
	
	Если ПустаяСтрока(КонтактнаяИнфо) Тогда
		НоваяКонтактная = УправлениеКонтактнойИнформациейСлужебный.АдресXMLВXDTO("");
		НоваяКонтактная.Комментарий = Комментарий;
		НоваяКонтактная = УправлениеКонтактнойИнформациейСлужебный.КонтактнаяИнформацияXDTOВXML(НоваяКонтактная);
		АдресВведенВСвободнойФорме = Ложь;
		
	ИначеЕсли УправлениеКонтактнойИнформациейКлиентСервер.ЭтоКонтактнаяИнформацияВXML(КонтактнаяИнфо) Тогда
		// Копия
		НоваяКонтактная = КонтактнаяИнфо;
		// Модифицируем значение "НоваяКонтактная".
		УправлениеКонтактнойИнформацией.УстановитьКомментарийКонтактнойИнформации(НоваяКонтактная, Комментарий);
		АдресВведенВСвободнойФорме = УправлениеКонтактнойИнформациейСлужебный.АдресВведенВСвободнойФорме(КонтактнаяИнфо);
		
	Иначе
		НоваяКонтактная = КонтактнаяИнфо;
		АдресВведенВСвободнойФорме = Ложь;
	КонецЕсли;
	
	Результат = Новый Структура("ДанныеВыбора, ОшибкиЗаполнения", Новый Структура, Новый СписокЗначений);
	Результат.ДанныеВыбора.Вставить("КонтактнаяИнформация", НоваяКонтактная);
	Результат.ДанныеВыбора.Вставить("Представление", Представление);
	Результат.ДанныеВыбора.Вставить("Комментарий", Комментарий);
	Результат.ДанныеВыбора.Вставить("ВведеноВСвободнойФорме", АдресВведенВСвободнойФорме);
	Возврат Результат;
КонецФункции

&НаКлиенте
Процедура ОтобразитьПоляПоТипуАдреса()
	
	НаселенныйПунктДетально.Country = СокрЛП(Страна);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗначениеРеквизитовПоКонтактнойИнформации(СведенияОбАдресе, ДанныеАдреса)
	
	// Общие реквизиты
	СведенияОбАдресе.ПредставлениеАдреса = ДанныеАдреса.Value;
	Если ДанныеАдреса.Свойство("Comment") Тогда
		СведенияОбАдресе.Комментарий         = ДанныеАдреса.Comment;
	КонецЕсли;
	
	// Копия комментария для анализа измененности.
	СведенияОбАдресе.КопияКомментария = СведенияОбАдресе.Комментарий;
	
	СсылкаНаОсновнуюСтрану = ОсновнаяСтрана();
	ДанныеСтраны = Неопределено;
	Если ДанныеАдреса.Свойство("Country") И ЗначениеЗаполнено(ДанныеАдреса.Country) Тогда
		ДанныеСтраны = Справочники.СтраныМира.ДанныеСтраныМира(, СокрЛП(ДанныеАдреса.Country));
	КонецЕсли;
	
	Если ДанныеСтраны = Неопределено Тогда
		// Не нашли ни в справочнике, ни в классификаторе.
		СведенияОбАдресе.Страна    = СсылкаНаОсновнуюСтрану;
		СведенияОбАдресе.КодСтраны = СсылкаНаОсновнуюСтрану.Код;
	Иначе
		СведенияОбАдресе.Страна    = ДанныеСтраны.Ссылка;
		СведенияОбАдресе.КодСтраны = ДанныеСтраны.Код;
	КонецЕсли;
	
	ЭлементыАдреса = Новый Массив;
	Если ЗначениеЗаполнено(ДанныеАдреса.city) Тогда
		ЭлементыАдреса.Добавить(ДанныеАдреса.city);
	КонецЕсли;
	Если ЗначениеЗаполнено(ДанныеАдреса.street) Тогда
		ЭлементыАдреса.Добавить(ДанныеАдреса.street);
	КонецЕсли;
	
	// поля адреса пустые, но представление заполнено
	Если ЭлементыАдреса.Количество() = 0 И ЗначениеЗаполнено(ДанныеАдреса.value) Тогда
		ДанныеАдреса.street = ДанныеАдреса.value;
		ЭлементыАдреса.Добавить(ДанныеАдреса.street);
	КонецЕсли;
	
	СведенияОбАдресе.ПредставлениеАдреса = СтрСоединить(ЭлементыАдреса, ", ");
	
КонецПроцедуры

&НаСервере
Процедура УдалитьГруппуЭлементов(Группа)
	Пока Группа.ПодчиненныеЭлементы.Количество()>0 Цикл
		Элемент = Группа.ПодчиненныеЭлементы[0];
		Если ТипЗнч(Элемент)=Тип("ГруппаФормы") Тогда
			УдалитьГруппуЭлементов(Элемент);
		КонецЕсли;
		Элементы.Удалить(Элемент);
	КонецЦикла;
	Элементы.Удалить(Группа);
КонецПроцедуры

&НаСервере
Процедура ОтобразитьИнформациюОДатахДействияАдреса(ДействуетС)
	
	Если ВводНовогоАдреса Тогда
		ТекстИсторическийАдрес = НСтр("ru = ''");
		АдресНаДату = ДействуетС;
		Элементы.ГруппаИсторическийАдрес.Видимость = ЗначениеЗаполнено(ДействуетС);
	Иначе
		
		Отбор = Новый Структура("Вид", ВидКонтактнойИнформации.Ссылка);
		НайденныеСтроки = КонтактнаяИнформацияОписаниеДополнительныхРеквизитов.НайтиСтроки(Отбор);
		Если НайденныеСтроки.Количество() = 0 
			ИЛИ (НайденныеСтроки.Количество() = 1 И ПустаяСтрока(НайденныеСтроки[0].Представление)) Тогда
				АдресНаДату = Дата(1, 1, 1);
				Элементы.ГруппаИсторическийАдрес.Видимость = Ложь;
				Элементы.ИсторияИзменений.Видимость = Ложь;
		Иначе
			Результат = ОпределитьДатуДействия(ДействуетС, НайденныеСтроки);
			АдресНаДату = Результат.ДействуетС;
			АдресДействуетС = Результат.ДействуетС;
			
			Если НЕ ЗначениеЗаполнено(Результат.ДействуетС)
				И ПустаяСтрока(Результат.ТекущаяСтрока.Представление) Тогда
					Элементы.ГруппаИсторическийАдрес.Видимость = Ложь;
			ИначеЕсли ЗначениеЗаполнено(Результат.ДействуетПо) Тогда
				ТекстИсторическийАдрес = " " + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'действует по %1'"), Формат(Результат.ДействуетПо - 10, "ДЛФ=DD"));
			Иначе
				ТекстИсторическийАдрес = НСтр("ru = 'действует по настоящее время.'");
			КонецЕсли;
			ОтобразитьКоличествоЗаписейВИсторииИзменений();
		КонецЕсли;
	КонецЕсли;
	
	Элементы.ТекстПроДатуДействия.Заголовок = ТекстИсторическийАдрес;
	Элементы.АдресНаДату.ФорматРедактирования = ?(ЗначениеЗаполнено(АдресНаДату), "", "ДФ='""" + НСтр("ru='начало учета'") + """'");
	
КонецПроцедуры

&НаСервере
Процедура ОтобразитьКоличествоЗаписейВИсторииИзменений()
	
	Отбор = Новый Структура("Вид", ВидКонтактнойИнформации.Ссылка);
	НайденныеСтроки = КонтактнаяИнформацияОписаниеДополнительныхРеквизитов.НайтиСтроки(Отбор);
	Если НайденныеСтроки.Количество() > 1 Тогда
		Элементы.ИсторияИзмененийГиперссылка.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='История изменений (%1)'"), НайденныеСтроки.Количество());
		Элементы.ИсторияИзмененийГиперссылка.Видимость = Истина;
	ИначеЕсли НайденныеСтроки.Количество() = 1 И ПустаяСтрока(НайденныеСтроки[0].ЗначенияПолей) Тогда
		Элементы.ИсторияИзмененийГиперссылка.Видимость = Ложь;
	Иначе
		Элементы.ИсторияИзмененийГиперссылка.Заголовок = НСтр("ru='История изменений'");
		Элементы.ИсторияИзмененийГиперссылка.Видимость = Истина;
	КонецЕсли;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ОпределитьДатуДействия(ДействуетС, История)
	
	Результат = Новый Структура("ДействуетПо, ДействуетС, ТекущаяСтрока");
	Если История.Количество() = 0 Тогда
		Возврат Результат;
	КонецЕсли;
	
	ТекущаяСтрока        = Неопределено;
	ДействуетПо          = Неопределено;
	Минимум              = -1;
	МинимумСравнительный = Неопределено;
	
	Для каждого СтрокаИстория Из История Цикл
		Дельта = СтрокаИстория.ДействуетС - ДействуетС;
		Если Дельта <= 0 И (МинимумСравнительный = Неопределено ИЛИ Дельта > МинимумСравнительный) Тогда
			ТекущаяСтрока        = СтрокаИстория;
			МинимумСравнительный = Дельта;
		КонецЕсли;

		Если Минимум = -1 Тогда
			Минимум       = Дельта + 1;
			ТекущаяСтрока = СтрокаИстория;
		КонецЕсли;
		Если Дельта > 0 И МодульЧисла(Дельта) < МодульЧисла(Минимум) Тогда
			ДействуетПо = СтрокаИстория.ДействуетС;
			Минимум     = МодульЧисла(Дельта);
		КонецЕсли;
	КонецЦикла;
	
	Результат.ДействуетПо   = ДействуетПо;
	Результат.ДействуетС    = ТекущаяСтрока.ДействуетС;
	Результат.ТекущаяСтрока = ТекущаяСтрока;
	
	Возврат Результат;
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция МодульЧисла(Число)
	Возврат Макс(Число, -Число);
КонецФункции

&НаКлиенте
Процедура ОчиститьАдресКлиент()
	
	Для каждого ЭлементАдреса Из НаселенныйПунктДетально Цикл
		
		Если ЭлементАдреса.Ключ = "Type" Тогда
			Продолжить;
		ИначеЕсли ЭлементАдреса.Ключ = "Buildings"  ИЛИ ЭлементАдреса.Ключ = "Apartments" Тогда
			НаселенныйПунктДетально[ЭлементАдреса.Ключ] = Новый Массив;
		Иначе
			НаселенныйПунктДетально[ЭлементАдреса.Ключ] = "";
		КонецЕсли;
		
	КонецЦикла;
	
	Если ВидКонтактнойИнформации.ТолькоНациональныйАдрес Тогда
		НаселенныйПунктДетально.Country = ОсновнаяСтрана();
	КонецЕсли;
	
	НаселенныйПунктДетально.AddressType = УправлениеКонтактнойИнформациейКлиентСервер.АдресВСвободнойФорме();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьКлючИспользованияФормы()
	КлючСохраненияПоложенияОкна = Строка(Страна);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////////////////////////

&НаСервере
Процедура ПриСозданииНаСервереХранитьИсториюИзменений()
	
	Если ВидКонтактнойИнформации.ХранитьИсториюИзменений Тогда
		Если Параметры.Свойство("КонтактнаяИнформацияОписаниеДополнительныхРеквизитов") Тогда
			Для каждого СтрокаКИ Из Параметры.КонтактнаяИнформацияОписаниеДополнительныхРеквизитов Цикл
				НоваяСтрока = КонтактнаяИнформацияОписаниеДополнительныхРеквизитов.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаКИ);
			КонецЦикла;
		Иначе
			Элементы.ИсторияИзменений.Видимость           = Ложь;
		КонецЕсли;
		Элементы.ИсторияИзмененийГиперссылка.Видимость = НЕ Параметры.Свойство("ИзФормыИстории");
		ВводНовогоАдреса = ?(Параметры.Свойство("ВводНовогоАдреса"), Параметры.ВводНовогоАдреса, Ложь);
		Если ВводНовогоАдреса Тогда
			ДействуетС = Параметры.ДействуетС;
		Иначе
			ДействуетС = ?(ЗначениеЗаполнено(Параметры.ДействуетС), Параметры.ДействуетС, ТекущаяДатаСеанса());
		КонецЕсли;
		ОтобразитьИнформациюОДатахДействияАдреса(ДействуетС);
	Иначе
		Элементы.ИсторияИзменений.Видимость           = Ложь;
		Элементы.ГруппаИсторическийАдрес.Видимость    = Ложь;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ОпределитьЗначениеАдреса(Параметры)
	
	Если Параметры.Свойство("Значение") Тогда
		Если ПустаяСтрока(Параметры.Значение) И ЗначениеЗаполнено(Параметры.ЗначенияПолей) Тогда
			ЗначенияПолей = Параметры.ЗначенияПолей;
		Иначе
			ЗначенияПолей = Параметры.Значение;
		КонецЕсли;
	Иначе
		ЗначенияПолей = Параметры.ЗначенияПолей;
	КонецЕсли;
	Возврат ЗначенияПолей;

КонецФункции

&НаСервере
Функция ИзвлечьСтарыйФорматАдреса(Знач ЗначенияПолей, Знач ТипКонтактнойИнформации)
	
	Перем XDTOКонтактная, РезультатыЧтения;
	
	Если УправлениеКонтактнойИнформациейКлиентСервер.ЭтоКонтактнаяИнформацияВXML(ЗначенияПолей)
		И ТипКонтактнойИнформации = Перечисления.ТипыКонтактнойИнформации.Адрес Тогда
		РезультатыЧтения = Новый Структура;
		XDTOКонтактная = УправлениеКонтактнойИнформациейСлужебный.КонтактнаяИнформацияИзXML(ЗначенияПолей, ТипКонтактнойИнформации, РезультатыЧтения);
		Если РезультатыЧтения.Свойство("ТекстОшибки") Тогда
			// Распознали с ошибками, сообщим при открытии.
			ТекстПредупрежденияПриОткрытии = РезультатыЧтения.ТекстОшибки;
			XDTOКонтактная.Представление   = Параметры.Представление;
			XDTOКонтактная.Состав.Страна   = Строка(ОсновнаяСтрана);
		КонецЕсли;
	Иначе
		XDTOКонтактная = УправлениеКонтактнойИнформациейСлужебный.АдресXMLВXDTO(ЗначенияПолей, Параметры.Представление, );
		Если Параметры.Свойство("Страна") И ЗначениеЗаполнено(Параметры.Страна) Тогда
			Если ТипЗнч(Параметры.Страна) = ТипЗнч(Справочники.СтраныМира.ПустаяСсылка()) Тогда
				XDTOКонтактная.Состав.Страна = Параметры.Страна.Наименование;
			Иначе
				XDTOКонтактная.Состав.Страна = Строка(Параметры.Страна);
			КонецЕсли;
		Иначе
			XDTOКонтактная.Состав.Страна = ОсновнаяСтрана.Наименование;
		КонецЕсли;
	КонецЕсли;
	Если Параметры.Комментарий <> Неопределено Тогда
		// Ставим новый комментарий, иначе он придет из информации.
		XDTOКонтактная.Комментарий = Параметры.Комментарий;
	КонецЕсли;
	Возврат XDTOКонтактная;

КонецФункции

&НаСервереБезКонтекста
Функция ОсновнаяСтрана()
	
	Если Метаданные.ОбщиеМодули.Найти("РаботаСАдресамиКлиентСервер") <> Неопределено Тогда
		
		МодульРаботаСАдресамиКлиентСервер = ОбщегоНазначения.ОбщийМодуль("РаботаСАдресамиКлиентСервер");
		Возврат МодульРаботаСАдресамиКлиентСервер.ОсновнаяСтрана();
		
	КонецЕсли;
	
	Возврат Справочники.СтраныМира.ПустаяСсылка();

КонецФункции

&НаСервере
Функция ПодготовитьАдресДляВвода(Данные)
	
	НаселенныйПунктДетально = УправлениеКонтактнойИнформациейКлиентСервер.ОписаниеНовойКонтактнойИнформации(ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Адрес"));
	ЗаполнитьЗначенияСвойств(НаселенныйПунктДетально, Данные);
	
	Для каждого ЭлементАдреса Из НаселенныйПунктДетально Цикл
		
		Если СтрЗаканчиваетсяНа(ЭлементАдреса.Ключ, "ID")
			И ТипЗнч(ЭлементАдреса.Значение) = Тип("Строка")
			И СтрДлина(ЭлементАдреса.Значение) = 36 Тогда
				НаселенныйПунктДетально[ЭлементАдреса.Ключ] = Новый УникальныйИдентификатор(ЭлементАдреса.Значение);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат НаселенныйПунктДетально;
	
КонецФункции

#КонецОбласти
﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения, Неопределено - Форма отчета или форма настроек отчета.
//       Неопределено когда вызов без контекста.
//   КлючВарианта - Строка, Неопределено - Имя предопределенного
//       или уникальный идентификатор пользовательского варианта отчета.
//       Неопределено когда вызов без контекста.
//   Настройки - Структура - см. возвращаемое значение
//       ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.ФормироватьСразу = Истина;
	Настройки.РазрешеноИзменятьСтруктуру = ОбщегоНазначения.РежимОтладки();
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// Возвращает сведения о внешнем отчете.
//
// Возвращаемое значение:
//   Структура - Подробнее см. ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке().
//
//Функция СведенияОВнешнейОбработке() Экспорт
//	ПараметрыРегистрации = ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке("2.2.4.1");
//	ПараметрыРегистрации.Информация = НСтр("ru = 'Отчет по документам ""Демо: Счет на оплату покупателю"". Используется для демонстрации возможностей подсистемы ""Дополнительные отчеты и обработки"".'");
//	ПараметрыРегистрации.Вид = ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиДополнительныйОтчет();
//	ПараметрыРегистрации.Версия = "2.4.1.1";
//	ПараметрыРегистрации.ОпределитьНастройкиФормы = Истина;
//	
//	Команда = ПараметрыРегистрации.Команды.Добавить();
//	Команда.Представление = НСтр("ru = 'Получить простой отчет...'");
//	Команда.Идентификатор = "ДополнительныйОтчетПолучитьПростойОтчет";
//	Команда.Использование = ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыОткрытиеФормы();
//	Команда.ПоказыватьОповещение = Ложь;
//	
//	Возврат ПараметрыРегистрации;
//КонецФункции

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
			СтандартнаяОбработка=ложь;
		Настройки = КомпоновщикНастроек.ПолучитьНастройки();
		ПараметрыДанных = Настройки.ПараметрыДанных;
		
		ПараметрыДанных.УстановитьЗначениеПараметра("ТолькоЭксперт", ложь);
		ОтборПлательщик=ложь;
		 Для каждого ии из Настройки.отбор.Элементы   цикл
			если   строка(ии.левоезначение)="Плательщик" и значениезаполнено(ии.правоезначение) и ии.использование=истина тогда
				ОтборПлательщик=истина;
			конецесли;
		КонецЦикла;
			//ПараметрыДанных.
		
		ПараметрыДанных.УстановитьЗначениеПараметра("ОтборПлательщик", ОтборПлательщик);

		Если не РольДоступна("ПолныеПрава") и не РольДоступна("Бухгалтер") и не РольДоступна("Аудитор")  тогда
			
			ПараметрыДанных.УстановитьЗначениеПараметра("ТолькоЭксперт", истина);
			ПараметрыДанных.УстановитьЗначениеПараметра("Эксперт", ПараметрыСеанса.ТекущийПользователь);
			
		КонецЕсли;
		
		
		КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
		МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки, ДанныеРасшифровки, , , Ложь);
		ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
		ПроцессорКомпоновки.Инициализировать(МакетКомпоновки,, ДанныеРасшифровки, Истина);
		ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
		ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
		ПроцессорВывода.Вывести(ПроцессорКомпоновки);

	//КлючВарианта = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства, "КлючВарианта");
	//Если КлючВарианта = "Исключение" Тогда
	//	СтандартнаяОбработка = Ложь;
	//	КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ОтчетПустой", Истина);
	//	ВызватьИсключение НСтр("ru = 'Прикладной текст исключения'");
	//КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
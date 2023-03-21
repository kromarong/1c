﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем


// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые не рекомендуется редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	
	Результат.Добавить("ИНН");
	Результат.Добавить("КодПоОКПО");
	Результат.Добавить("КПП");
	
	Результат.Добавить("КонтактнаяИнформация.*");
	
	Возврат Результат;
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// СтандартныеПодсистемы.ВариантыОтчетов

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

// СтандартныеПодсистемы.Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	Настройки.ПриПолученииСлужебныхРеквизитов = Истина;
КонецПроцедуры

// Ограничивает видимость реквизитов объекта в отчете по версии.
//
// Параметры:
//  Реквизиты - Массив - список имен реквизитов объекта.
Процедура ПриПолученииСлужебныхРеквизитов(Реквизиты) Экспорт
	Реквизиты.Добавить("ЭтоИностранныйКонтрагент");
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// СтандартныеПодсистемы.ПодключаемыеКоманды

// Определяет список подключаемых команд для вывода в подменю "ПодменюДемоКоманд" у произвольных объектов конфигурации.
// Подробнее см. ПодключаемыеКомандыПереопределяемый.ПриОпределенииВидовПодключаемыхКоманд.
//
// Параметры:
//   ДемоКоманды - ТаблицаЗначений - добавить в таблицу собственные подключаемые команды. Состав колонок см. в описании
//       параметра Команды процедуры ПодключаемыеКомандыПереопределяемый.ПриОпределенииКомандПодключенныхКОбъекту.
//   Параметры - Структура - вспомогательные входные параметры, необходимые для формирования команд.
//       См. описание параметра НастройкиФормы процедуры ПодключаемыеКомандыПереопределяемый.ПриОпределенииКомандПодключенныхКОбъекту.
//
Процедура ДобавитьДемоКоманды(ДемоКоманды, Параметры) Экспорт
	
КонецПроцедуры

// Определяет список команд заполнения.
//
// Параметры:
//   КомандыЗаполнения - ТаблицаЗначений - Таблица с командами заполнения. Для изменения.
//       См. описание 1 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//
Процедура ДобавитьКомандыЗаполнения(КомандыЗаполнения, Параметры) Экспорт
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	
	//Ограничение.Текст =
	//"РазрешитьЧтениеИзменение
	//|ГДЕ
	//|	ЭтоГруппа
	//|	ИЛИ ЗначениеРазрешено(Партнер)";
	//
	//Ограничение.ТекстДляВнешнихПользователей =
	//"ПрисоединитьДополнительныеТаблицы
	//|ЭтотСписок КАК Контрагенты
	//|
	//|ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВнешниеПользователи КАК ВнешниеПользователиПартнеры
	//|	ПО ВнешниеПользователиПартнеры.ОбъектАвторизации = Контрагенты.Партнер
	//|
	//|ЛЕВОЕ СОЕДИНЕНИЕ Справочник._ДемоКонтактныеЛицаПартнеров КАК _ДемоКонтактныеЛицаПартнеров
	//|	ПО _ДемоКонтактныеЛицаПартнеров.Владелец = Контрагенты.Партнер
	//|
	//|ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВнешниеПользователи КАК ВнешниеПользователиКонтактныеЛица
	//|	ПО ВнешниеПользователиКонтактныеЛица.ОбъектАвторизации = _ДемоКонтактныеЛицаПартнеров.Ссылка
	//|;
	//|РазрешитьЧтениеИзменение
	//|ГДЕ
	//|	ЭтоГруппа
	//|	ИЛИ ЗначениеРазрешено(ВнешниеПользователиПартнеры.Ссылка)
	//|	ИЛИ ЗначениеРазрешено(ВнешниеПользователиКонтактныеЛица.Ссылка)";
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли
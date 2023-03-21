﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет список обработчиков (модулей менеджеров или общих модулей) для формирования и обновления
// списка всех текущих дел, предусмотренных в конфигурации.
//
// В указанных модулях должна быть размещена процедура обработчика, в которую передаются параметры:
//  ТекущиеДела - ТаблицаЗначений - определяет параметры дела:
//    * Идентификатор  - Строка - внутренний идентификатор дела, используемый подсистемой.
//    * ЕстьДела       - Булево - если Истина, дело выводится в списке текущих дел пользователя.
//    * Важное         - Булево - если Истина, дело будет выделено красным цветом.
//    * СкрыватьВНастройках - Булево - если Истина, то дело будет скрыто в форме настроек текущих дел.
//                            Можно применять для дел, которые не предполагают многократного
//                            использования, т.е. после выполнения они для данной информационной базы
//                            больше отображаться не будут.
//    * Представление  - Строка - представление дела, выводимое пользователю.
//    * Количество     - Число  - количественный показатель дела, выводится в строке заголовка дела.
//    * Форма          - Строка - полный путь к форме, которую необходимо открыть при нажатии на гиперссылку
//                                дела на панели "Текущие дела".
//    * ПараметрыФормы - Структура - параметры, с которыми нужно открывать форму показателя.
//    * Владелец       - Строка, объект метаданных - строковый идентификатор дела, которое будет владельцем для текущего
//                       или объект метаданных подсистема.
//    * Подсказка      - Строка - текст подсказки.
// 
// Далее пример процедуры обработчика для копирования в указанные модули.
//
//// См. ТекущиеДелаПереопределяемый.ПриОпределенииОбработчиковТекущихДел.
//Процедура ПриЗаполненииСпискаТекущихДел(ТекущиеДела) Экспорт
//
//КонецПроцедуры
//
// Параметры:
//  Обработчики - Массив - модули менеджеров или общие модули,
//                         например: Документы.ЗаказПокупателя, ТекущиеДелаПоПродажам.
// Пример:
//  Обработчики.Добавить(Документы.ЗаказПокупателя);
//
Процедура ПриОпределенииОбработчиковТекущихДел(Обработчики) Экспорт
	
	
	
КонецПроцедуры

// Задает начальный порядок разделов в панели текущих дел.
//
// Параметры:
//  Разделы - Массив - массив разделов командного интерфейса.
//                     Разделы в панели текущих дел выводятся в
//                     том порядке, в котором они были добавлены в массив.
//
Процедура ПриОпределенииПорядкаРазделовКомандногоИнтерфейса(Разделы) Экспорт
	
	
	
КонецПроцедуры

// Определяет текущие дела, которые не будут выводиться пользователю.
//
// Параметры:
//  ОтключаемыеДела - Массив - массив строк идентификаторов текущих дел, которые нужно отключать.
//
Процедура ПриОтключенииТекущихДел(ОтключаемыеДела) Экспорт
	
КонецПроцедуры

// Позволяет менять некоторые настройки подсистемы.
//
// Параметры:
//  Параметры - Структура - со свойствами:
//     * ЗаголовокПрочихДел - Строка - заголовок раздела, в который выводятся
//                            дела, не отнесенные к разделам командного интерфейса.
//                            Применимо для тех дел, размещение которых в панели
//                            определяется функцией ТекущиеДелаСервер.РазделыДляОбъекта.
//                            Если не указано - дела выводятся в группу с заголовком
//                            "Прочие дела".
//
Процедура ПриОпределенииНастроек(Параметры) Экспорт
	
	
	
КонецПроцедуры

// Позволяет установить параметры запросов, общие для нескольких текущих дел.
//
// Например, если в нескольких обработчиках получения текущих дел устанавливается
// параметр "ТекущаяДата", то установку параметра можно прописать в данной
// процедуре, а в обработчике формирования дела сделать вызов процедуры
// ТекущиеДела.УстановитьОбщиеПараметрыЗапросов(), которая установит данный параметр.
//
// Параметры:
//  Запрос - Запрос - выполняемый запрос.
//  ОбщиеПараметрыЗапросов - Структура - общие значения для расчета текущих дел.
//
Процедура УстановитьОбщиеПараметрыЗапросов(Запрос, ОбщиеПараметрыЗапросов) Экспорт
	
КонецПроцедуры

// Процедура-обработчик, которую можно вызывать в формах расшифровки текущих дел
// для переопределения параметров открытия формы и установки необходимых отборов списках формы.
//
// Параметры:
//  Форма  - ФормаКлиентскогоПриложения - форма, из которой был осуществлен вызов метода.
//  Список - ДинамическийСписок - список, параметры которого можно переопределить.
//
Процедура ПриСозданииНаСервере(Форма, Список) Экспорт
	
КонецПроцедуры

// Процедура-обработчик, которую можно вызывать в соответствующем обработчике форм
// расшифровки текущих дел для замены сохраненных значений реквизитов формы.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, из которой был осуществлен вызов метода.
//  Настройки - Соответствие - настройки формы, в которых находятся значения реквизитов.
//
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Форма, Настройки) Экспорт
	
КонецПроцедуры

#КонецОбласти
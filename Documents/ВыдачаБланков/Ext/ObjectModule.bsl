﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	
	если   значениезаполнено(ВидБланка) и  значениезаполнено(Эксперт) 
		и не (ДополнительныеЛисты=0 и (НачальныйНомер=0 или КонечныйНомер=0) )  тогда
	
	
	Если ДополнительныеЛисты   >0 Тогда 
		Движения.УчетДополнительныхЛистов.Записывать = Истина;
		Движение = Движения.УчетДополнительныхЛистов.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период = Дата;
		Движение.Эксперт = Эксперт;
		Движение.Организация = Организация;
		Движение.ДопЛистов = ДополнительныеЛисты;
		Движение.ВидСертификата=ВидБланка;
	КонецЕсли;
	
	
	Если НачальныйНомер  >    0 и КонечныйНомер>=НачальныйНомер тогда
		мен=РегистрыСведений.НомераБланков.СоздатьМенеджерЗаписи();
		для  ии = НачальныйНомер по КонечныйНомер цикл
			мен.Номер=ии;
			мен.Прочитать();
			
			Если  мен.Выбран() тогда
				мен.Удалить();
			КонецЕсли ;	  
			
			Если не мен.Выбран() тогда
				мен.номер=ии   ;
				мен.ВидСертификата=ВидБланка;
				//мен.ДатаВыдачи=ТекущаяДата();
				мен.ДатаВыдачи=Дата;
				мен.Организация=Организация;
				мен.Эксперт=Эксперт;
				мен.СтатусБланка=Перечисления.СтатусыБланков.Выдан;
				мен.Записать();
			КонецЕсли 
			
		КонецЦикла;
		
	КонецЕсли
	
	иначе
	
	сообщить("Не заполнены необх. данные");
	Отказ=истина;
	КонецЕсли
	
КонецПроцедуры


Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	Если ДанныеЗаполнения = Неопределено Тогда // Ввод нового.
		ЭкспертизаИСертификация.ПриВводеНовогоЗаполнитьОрганизацию(ЭтотОбъект);
		//Эксперт = Пользователи.ТекущийПользователь();
		Ответственный = Пользователи.ТекущийПользователь();
	КонецЕсли;
КонецПроцедуры




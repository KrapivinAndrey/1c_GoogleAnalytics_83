﻿//ВСПОМОГАТЕЛЬНЫЕ

Функция URLАдреса()
	Результат = Новый Структура;
	Результат.Вставить("GoogleAnalytics", "www.google-analytics.com");
	Результат.Вставить("Work", "/collect");
	Результат.Вставить("Test", "/debug");
	
	Возврат Результат;
КонецФункции

//РАБОТА С ВРЕМЕННЫМ ХРАНИЛИЩЕМ {
Процедура ПоместитьВоВХ(Имя,Значение) Экспорт
	
	ПоместитьВоВременноеХранилище(Значение, ПараметрыКлиентСерверGA.АдресаВХ[Имя]);
				
КонецПроцедуры

Функция ИзвлечьИзВХ(Имя) Экспорт
	
	АдресВХ = ПараметрыКлиентСерверGA.АдресаВХ[Имя];
	
	Если Не ЭтоАдресВременногоХранилища(АдресВХ) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ПолучитьИзВременногоХранилища(АдресВХ);
			
КонецФункции

Функция ПолучитьУникальныйИдентификаторДляВХ(ОсновнаяФорма)
	
	УникальныйИдентификатор = Новый УникальныйИдентификатор;
	
	Если ТипЗнч(ОсновнаяФорма) = Тип("УправляемаяФорма") Тогда
		УникальныйИдентификатор = ОсновнаяФорма.УникальныйИдентификатор;
	КонецЕсли;
	
	Возврат УникальныйИдентификатор;
	
КонецФункции

//}

Функция ИнициализироватьПараметрыКлиентСервер(ОсновнаяФорма = Неопределено) Экспорт
	ПараметрыКлиентСерверGA = Новый Структура;
	
	ПараметрыКлиентСерверGA.Вставить("АдресаВХ");
	
	ПараметрыКлиентСерверGA.Вставить("URLАдреса");
	ПараметрыКлиентСерверGA.Вставить("ПутьКФормам");

	
	ПараметрыКлиентСерверGA.Вставить("ВерсияПлатформы1С");
	ПараметрыКлиентСерверGA.Вставить("ИмяКонфигурации1С");
	ПараметрыКлиентСерверGA.Вставить("НомерРелизаМодуля1С");
	
	ПараметрыКлиентСерверGA.Вставить("ТипИспользуемыхФорм");
	ПараметрыКлиентСерверGA.Вставить("МодальностьЗапрещена");
	ПараметрыКлиентСерверGA.Вставить("Асинхронность");
	
	ПараметрыКлиентСерверGA.Вставить("tid"); //ключевой параметр - трекер ид проекта в аналитике
	ПараметрыКлиентСерверGA.Вставить("cid"); //идентификация пользователя
	ПараметрыКлиентСерверGA.Вставить("ОбязательныеПараметры");
	
	УникальныйИдентификатор	= ПолучитьУникальныйИдентификаторДляВХ(ОсновнаяФорма);
	
	АдресаВХ = Новый Структура;
	АдресаВХ.Вставить("СоединениеГА",									ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор));
	АдресаВХ.Вставить("СтекСобытий"	,									ПоместитьВоВременноеХранилище(Новый Массив, УникальныйИдентификатор)); //сюда замеры и события не с основной формы
	АдресаВХ.Вставить("РежимТестирования",								ПоместитьВоВременноеХранилище(Ложь		  , УникальныйИдентификатор)); //сюда замеры и события не с основной формы
		
	ПараметрыКлиентСерверGA.АдресаВХ					= АдресаВХ;
	
	ПараметрыКлиентСерверGA.URLАдреса					= URLАдреса();
	ПараметрыКлиентСерверGA.ПутьКФормам					= Метаданные().ПолноеИмя() + ".Форма.";
	
	ПараметрыКлиентСерверGA.ВерсияПлатформы1С			= ВерсияПлатформы1С();
	ПараметрыКлиентСерверGA.ИмяКонфигурации1С			= ИмяКонфигурации1С();
	ПараметрыКлиентСерверGA.НомерРелизаМодуля1С			= НомерРелизаМодуля1С();
	
	ПараметрыКлиентСерверGA.ТипИспользуемыхФорм			= ТипИспользуемыхФорм(ОсновнаяФорма);
	ПараметрыКлиентСерверGA.МодальностьЗапрещена		= МодальностьЗапрещена();
	ПараметрыКлиентСерверGA.Асинхронность				= АсинхронныйРежим();
	
	ПараметрыКлиентСерверGA.tid = "UA-101999436-2";
	ПараметрыКлиентСерверGA.cid = ПользователиИнформационнойБазы.ТекущийПользователь().УникальныйИдентификатор;
	
	ПараметрыКлиентСерверGA.ОбязательныеПараметры		= "v=1&tid=" + ПараметрыКлиентСерверGA.tid + "&cid=" + ПараметрыКлиентСерверGA.cid;
	ПараметрыКлиентСерверGA.РежимТестирования			= Ложь;

	Возврат ПараметрыКлиентСерверGA;
КонецФункции

Функция ПолучитьНомерРелиза() Экспорт
	               	
	Возврат "0.0.2b";
	
КонецФункции

Функция СтрокаСодержащаяРазрешенныеСимволы(Строка, РазрешенныеСимволы)
	
	//в параметре РазрешенныеСимволы буквы должны указываться в нижнем регистре
	
	Результат = ""; 
		
	ДлинаСтроки = СтрДлина(Строка);
	Для К = 1 По ДлинаСтроки Цикл
		Символ = Прав(Лев(Строка,К),1);
		НРегСимвол = НРег(Символ);
		СимволРазрешен = ( Найти(РазрешенныеСимволы,НРегСимвол) > 0 );
		Если СимволРазрешен Тогда
			Результат = Результат + Символ;			
		КонецЕсли;
	КонецЦикла;
				
	Возврат Результат;
	
КонецФункции

//ИНИЦИАЛИЗАЦИЯ ПАРАМЕТРОВ{
Функция ВерсияПлатформы1С()
	
	Результат = "";

	Попытка
		СистемнаяИнформация = Новый СистемнаяИнформация;
		Результат = СистемнаяИнформация.ВерсияПриложения;
	Исключение
		_ОписаниеОшибки = ОписаниеОшибки();	
	КонецПопытки;	
		
	Возврат Результат;	
	
КонецФункции

Функция ИмяКонфигурации1С()
	Имя = "";
	Попытка
		Имя = Метаданные.Имя;
	Исключение
		_ОписаниеОшибки = ОписаниеОшибки();	
	КонецПопытки;
	Возврат Имя;

КонецФункции

Функция НомерРелизаМодуля1С()
	
	РазрешенныеСимволы = "0123456789.bk";
	НомерРелиза = ПолучитьНомерРелиза();
	
	Возврат СтрокаСодержащаяРазрешенныеСимволы(НомерРелиза, РазрешенныеСимволы);	
	
КонецФункции

Функция ТипИспользуемыхФорм(Форма)
	
	Результат = Ложь;
	
	Если ТипЗнч(Форма) = Тип("УправляемаяФорма") Тогда
		Результат = "Управляемые";
	Иначе
		Результат = "Обычные";
	КонецЕсли;
	
	Возврат Результат;	
	
КонецФункции

Функция МодальностьЗапрещена()
	
	СисИнфо = Новый СистемнаяИнформация;
	ТекВерсияПлатформы = СисИнфо.ВерсияПриложения;
	Остаток = Сред(СокрЛП(ТекВерсияПлатформы),3);
	ВтораяЦифраВерсии = Число(Лев(Остаток,1)); //скорее всего 8.10.х не будет
	Остаток = Сред(СокрЛП(Остаток),3);
	ТретьяЦифраВерсии = Число(Лев(Остаток,Найти(Остаток,".")-1));
	
	Если (ВтораяЦифраВерсии = 3 и ТретьяЦифраВерсии >= 4) или ВтораяЦифраВерсии > 3 Тогда 
		Попытка
			Если Строка(Метаданные.РежимИспользованияМодальности)  = "Использовать" Тогда 
				Возврат Ложь;
			Иначе
				Возврат Истина;
			КонецЕсли;
		Исключение
			//платфома не в курсе что есть режим отказа от модальности
			Возврат Ложь;
		КонецПопытки;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

Функция АсинхронныйРежим()
	
КонецФункции
//}

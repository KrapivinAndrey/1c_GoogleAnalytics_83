﻿//ВСПОМОГАТЕЛЬНЫЕ

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


Функция URLАдреса()
	Результат = Новый Структура;
	Результат.Вставить("GoogleAnalytics", "www.google-analytics.com");
	Результат.Вставить("Work",		"/collect");
	Результат.Вставить("Group",		"/batch");
	Результат.Вставить("Test",		"/debug");
	
	Возврат Результат;
КонецФункции

#Область Работа_с_временным_хранилищем

Процедура GA_ПоместитьВоВХ(Имя,Значение) Экспорт
	
	ПоместитьВоВременноеХранилище(Значение, ПараметрыКлиентСерверGA.АдресаВХ[Имя]);
				
КонецПроцедуры

Функция GA_ИзвлечьИзВХ(Имя) Экспорт
	
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

#КонецОбласти

#Область Обязательные_параметры
Функция ПолучитьИдентификаторПроекта()
	Возврат "UA-101999436-2"
КонецФункции

Функция ПолучитьИдентификаторПользователя()
	Возврат ПользователиИнформационнойБазы.ТекущийПользователь().УникальныйИдентификатор
КонецФункции
#КонецОбласти

Функция ИнициализироватьПараметрыКлиентСервер(ОсновнаяФорма = Неопределено) Экспорт
	ПараметрыКлиентСерверGA = Новый Структура;
	
	ПараметрыКлиентСерверGA.Вставить("АдресаВХ");
	
	ПараметрыКлиентСерверGA.Вставить("URLАдреса");
	ПараметрыКлиентСерверGA.Вставить("ПутьКФормам");

	ПараметрыКлиентСерверGA.Вставить("МодальностьЗапрещена");
	ПараметрыКлиентСерверGA.Вставить("Асинхронность");
	
	ПараметрыКлиентСерверGA.Вставить("tid"); //ключевой параметр - трекер ид проекта в аналитике
	ПараметрыКлиентСерверGA.Вставить("cid"); //идентификация пользователя
	ПараметрыКлиентСерверGA.Вставить("ОбязательныеПараметры");
	
	УникальныйИдентификатор	= ПолучитьУникальныйИдентификаторДляВХ(ОсновнаяФорма);
	
	АдресаВХ = Новый Структура;
	АдресаВХ.Вставить("СоединениеГА",					ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор));
	АдресаВХ.Вставить("СтекСобытий"	,					ПоместитьВоВременноеХранилище(Новый Массив, УникальныйИдентификатор)); //сюда замеры и события не с основной формы
	АдресаВХ.Вставить("РежимТестирования",				ПоместитьВоВременноеХранилище(Ложь		  , УникальныйИдентификатор)); //признак тестирования отправки
	АдресаВХ.Вставить("ОтправкаЗапрещена",				ПоместитьВоВременноеХранилище(Ложь		  , УникальныйИдентификатор)); //признак отключения отправки
		
	ПараметрыКлиентСерверGA.АдресаВХ					= АдресаВХ;
	
	ПараметрыКлиентСерверGA.URLАдреса					= URLАдреса();
	ПараметрыКлиентСерверGA.ПутьКФормам					= Метаданные().ПолноеИмя() + ".Форма.";
	
	ПараметрыКлиентСерверGA.МодальностьЗапрещена		= МодальностьЗапрещена();
	ПараметрыКлиентСерверGA.Асинхронность				= АсинхронныйРежим();
	
	ПараметрыКлиентСерверGA.tid 						= ПолучитьИдентификаторПроекта();
	ПараметрыКлиентСерверGA.cid 						= ПолучитьИдентификаторПользователя();
	
	ПараметрыКлиентСерверGA.ОбязательныеПараметры		= "v=1&tid=" + ПараметрыКлиентСерверGA.tid + "&cid=" + ПараметрыКлиентСерверGA.cid;

	Возврат ПараметрыКлиентСерверGA;
КонецФункции


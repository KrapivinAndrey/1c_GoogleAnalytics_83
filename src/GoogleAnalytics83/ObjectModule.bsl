﻿Перем СоединениеGA;
//ВСПОМОГАТЕЛЬНЫЕ

Функция ПолучитьТекстЯчейкиОбласти(Область, Строка, Колонка) Экспорт
	Возврат Строка(Область.ПолучитьОбласть("R" + Формат(Строка, "ЧГ = 0")+"C" + Формат(Колонка, "ЧГ = 0")).ТекущаяОбласть.Текст);
КонецФункции

Функция ПрочитатьДополнительныеПараметры()
	Макет = ПолучитьМакет("ДополнительныеПараметры");
	Результат = Новый Соответствие;
	Для Сч = 2 По макет.ВысотаТаблицы Цикл
		Результат.Вставить(ПолучитьТекстЯчейкиОбласти(Макет, Сч, 1),
							ПолучитьТекстЯчейкиОбласти(Макет, Сч, 2));
	КонецЦикла;
						
	Возврат Результат;					
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

Функция ИнициализироватьПараметрыКлиентСервер(TID, CID, ОсновнаяФорма = Неопределено) Экспорт
	ПараметрыКлиентСерверGA = Новый Структура;
	
	ПараметрыКлиентСерверGA.Вставить("АдресаВХ");
	
	ПараметрыКлиентСерверGA.Вставить("URLАдреса");
	ПараметрыКлиентСерверGA.Вставить("ПутьКФормам");

	ПараметрыКлиентСерверGA.Вставить("tid"); //ключевой параметр - трекер ид проекта в аналитике
	ПараметрыКлиентСерверGA.Вставить("cid"); //идентификация пользователя
	
	ПараметрыКлиентСерверGA.Вставить("ИмяПриложения");
	ПараметрыКлиентСерверGA.Вставить("ДополнительныеПараметры");
	
	УникальныйИдентификатор	= ПолучитьУникальныйИдентификаторДляВХ(ОсновнаяФорма);
	
	АдресаВХ = Новый Структура;
	АдресаВХ.Вставить("СоединениеGA",					ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор));
	АдресаВХ.Вставить("СтекСобытий"	,					ПоместитьВоВременноеХранилище(Новый Массив, УникальныйИдентификатор)); //сюда замеры и события не с основной формы
	АдресаВХ.Вставить("РежимТестирования",				ПоместитьВоВременноеХранилище(Ложь		  , УникальныйИдентификатор)); //признак тестирования отправки
	АдресаВХ.Вставить("ОтправкаЗапрещена",				ПоместитьВоВременноеХранилище(Ложь		  , УникальныйИдентификатор)); //признак отключения отправки
		
	ПараметрыКлиентСерверGA.АдресаВХ					= АдресаВХ;
	
	ПараметрыКлиентСерверGA.URLАдреса					= URLАдреса();
	ПараметрыКлиентСерверGA.ПутьКФормам					= Метаданные().ПолноеИмя() + ".Форма.";
	
	ПараметрыКлиентСерверGA.tid 						= TID;
	ПараметрыКлиентСерверGA.cid 						= CID;
	
	ПараметрыКлиентСерверGA.ИмяПриложения				= Метаданные().Имя;
	ПараметрыКлиентСерверGA.ДополнительныеПараметры		= ПрочитатьДополнительныеПараметры();

	Возврат ПараметрыКлиентСерверGA;
КонецФункции

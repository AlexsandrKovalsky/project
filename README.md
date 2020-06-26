# Проект по курсу Qt: “Планировщик” + инструкция по сборке
Цель:облегчить постановку целей, задач и действий пользователям.

Зачада: создать Desktop приложение, где пользователи смогут составлять список дел на каждый день и отмечать их выполнение. Интерфейс - на qml, бизнес логика – C++.

Проект состоит из базы данных и самого приложения, которое работает с ней и отображает содержимое.

База данных  состоит из одной таблицы, созданная при помощи sql, в которой пользователь хранит  всю информацию о своих задачах и целях в виде 5 столбцов  (id задачи, описание, выполнено/не выполнено, приоритет задачи, дата). Приоритет задачи задается по 10-бальной шкале и делится на: Оч.Высокий(>= 9), Высокий (>= 7), Средний (>= 5), Низкий (>=3), Оч.Низкий(>=0).

Приложение представляет собой отображение базы данных и позволяет  выполнять некоторые действия над ней:

		•Добавление задачи
		•Изменение 
		•Удаление
		•Отметка о выполнении
		
 Оно состоит из главного окна с тремя вкладками: 
 
	•Календарь - это основной раздел, где пользователь работает с задачами на выбранный день.
	•Важное - раздел, где отображаются задачи за несколько дней с сортировкой по приоритету (вверху самые важные)
	•Горящие сроки - раздел, где отображаются задачи, в зависимости от срока их наступления и помечаются тремя цветами: Красный- задача просрочена, Оранжевый- срок задачи истекает в текущий день или через день, Зеленый- до истечения срока задачи остается два дня. 

Задачи в каждом разделе отображаются в виде списка.

# Фичи:

	•Добавление/Удаление/Изменение задач
	•Запись всей информации в базу данных
	•Отображение задач в виде списка
	•Отметка о выполнении задач + отображение прогресса в процентах за каждый день и за все дни в общем 
	•Планирование задач на предстоящие дни	
# Требования для запуска приложения:

	•QT 5.14.2
	•QT Quick
	•Комплект: MinGW 64-bit

# Инструкция по сборке:
Для запуска необходимо открыть и собрать проект MyDailyTasksApp в среде Qt Creator.

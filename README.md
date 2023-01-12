# iOS-приложение ShopManagement

Приложение для отправки чеков через WhatsApp, данные используются из Google таблицы, которая должна иметь следующий формат:
1. Наименование	
2. Цена продажи	
3. Ссылка на чек	
4. Фото	
5. Описание
<img width="971" alt="image" src="https://user-images.githubusercontent.com/68683848/208134826-e0f61713-3ec8-4f02-8efa-ebdc8cb388af.png">

[Пример таблицы](https://docs.google.com/spreadsheets/d/1HvXfgK2VJBIvJEWVHD4jy4ClPLzfh_l-CUDX0AxiEnA/edit#gid=0)

Для просмотра у Google аккаунта должен быть доступ к просмотру таблицы.

Прилоржение разработано полностью на языке Swift.

Макет приложения: [Figma](https://www.figma.com/file/W9c5oL4YeowqIRdIerD2qf/ShopManagment?node-id=1%3A3&t=UUYm5LPRC7wkr2ZU-0)

Была использована авторизация через google аккаунт, с применением библиотеки [Google Sign-In](https://github.com/google/GoogleSignIn-iOS).

Взаимодействие с таблицей реализовано через [Google Sheets API](https://developers.google.com/sheets/api/)

Отправка сообщений осуществлялась через [Whatsapp API](https://api.whatsapp.com)

Чтобы уменьшить количество загружаемых данных, была реализовано кэширование изображенией через кастомную UIVIew.

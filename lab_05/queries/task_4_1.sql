/*
	Извлечь json фрагмент из json документа
*/

select doc->'id' as id, doc->'animal_name' as name
from animals_import

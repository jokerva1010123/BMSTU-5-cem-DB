/*
	Извлечь значения конкретных узлов или атрибутов json документа
*/

select *
from animals_import
where (doc->>'id')::INT > 8 and (doc->>'id')::INT < 15;
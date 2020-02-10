---full text search 
 --refers to techniques for searching a single computer stored document 
 --like can be used to search the text in the documents but it has limitation like it wont go further than matching exact key word
select * from table where compnay '%apple%' ---matches only with apples and wont consider (Apple,apples words as valid for the search)


/*to_tsvector -- which helps to set the language  settings and convert the tokens into standard tokens
            --creates a normalied vector 
to_toquery  --which query with the words that will be checked against the vector for matching.

*/

update part set partdescr='aluminium foils are used to make this part' where id=300000;

select * from part where to_tsvector('english',partdescr) @@ to_tsquery('Foil');
/*

   id   |   partno   |  partname   |                 partdescr                  | machine_id 
--------+------------+-------------+--------------------------------------------+------------
 300000 | Pno:300000 | Part:300000 | aluminium foils are used to make this part |          0
*/
 ---we can use and (&),or(|), negation operator(!) in the to_tsquery to match with multiple words..

/* 

  <-> is used enhance the to_tsquery which is used to search for phrases in the document,till its possible to search only tokens or set of tokens (the overall continous phrase is not possible) as if we mention all the set of word to match with phrase it may fetch rows which are also not continous phrase as the tokens might match similar word in the text..
 
<-> to match the tokens immediately one after the other.
<2> to match the tokens immediately with leaving one word in between.
change the proximity to identify the phrase 
*/
select doc_id,doc_text from documents where doc_tokens @@to_tsquery('zebra<->jump');
/*
 doc_id |               doc_text               
--------+--------------------------------------
      4 | How vexingly quick daft zebras jump!

*/

 ---Black is one word after the sphnix(Sphinx of black quartz, judge my vow.)
select doc_id,doc_text from documents where doc_tokens @@to_tsquery('Sphinx<2>black');

/*
featurs of full text search 
search dicts ---allows to build text search dictionaries
CREATE TEXT SEARCH DICTIONARY pg_dict (
    TEMPLATE = synonym,
    SYNONYMS = pg_dict
)
search configurations---specifes all the options necessary to transform a document into a tsvector..

CREATE TEXT SEARCH CONFIGURATION public.pg ( COPY = pg_catalog.english );

Ranking and weights---rankking the search results(measure how relevant are to a particular query)

*/





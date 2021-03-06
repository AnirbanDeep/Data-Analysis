tweet = Load'tweetsp'using PigStorage('\t')as(id:long,timestamp:chararray,tweet_count:int,text:chararray,screen_name:chararray,followers_count:chararray,time_zone:chararray);
dump tweet;
timezone = Load'time_zone_map.tsv'using PigStorage('\t')as(time_zone:chararray,country:chararray,notes:chararray);
dump timezone;
dictionary = Load'dictionary.tsv'using PigStorage('\t')as(type:chararray,length:int,word:chararray,pos:chararray,stemmed:chararray,polarity:chararray);
dump dictionary;
twords = foreach tweet generate id,FLATTEN(TOKENIZE(text)) AS word;
dump twords;
tsentiment = join twords by word left outer, dictionary by word using'replicated';
dump tsentiment;
wscore = foreach tsentiment generate twords::id as id, (CASE dictionary::polarity WHEN 'positive' THEN 1 WHEN 'negative' THEN -1 else 0 END) as score;
dump wscore;
tgroup = group wscore by id;
dump tgroup;
tscore = foreach tgroup generate group as id, SUM(wscore.score) as final;
dump tscore;
tweetstz = join tweet by time_zone left outer, timezone by time_zone using 'replicated';
dump tweetstz;
tcountry = foreach tweetstz generate tweet::id as id, timezone::country as country;
dump tcountry;
tcomplete = join tscore by id left outer, tcountry by id;
dump tcomplete;
tclassify = foreach tcomplete generate tscore::id as id, tcountry::country as country, ( (tscore::final > 0)? 1 : 0 ) as positive, ( (tscore::final < 0)? 1 : 0 ) as negative;
dump tclassify;
groupByCountries = group tclassify by country;
dump groupByCountries;
sentimentByCountries = foreach groupByCountries generate group, SUM( tclassify.positive ), SUM ( tclassify.negative );
dump sentimentByCountries;
store sentimentByCountries into '/home/hadoop/Desktop/result';


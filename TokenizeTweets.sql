create schema twitter;

alter table twitter.tokens
drop column frequency;

create table twitter.tokens
(
token varchar(150)
);

create table twitter.tweets
(
rowid int identity(1,1),
tweet nvarchar(150)
);

insert into twitter.tweets(tweet)
values('My name is sravika'),
       ('I am sravika'),
	   ('He is everything to me'),
	   ('My dearest darling krishna');

alter procedure twitter.tokenize
(@string_input varchar(150))
as 
begin
insert into twitter.tokens(token)
select distinct value 
from string_split(@string_input,' ');
end

alter procedure twitter.split_sentence
as
begin
declare @row_num int=1;
declare @num_rows int= (select count(*) from tweets);

while (@row_num <= @num_rows)
begin

     declare @string varchar(150);
     set @string=(select tweet 
     from twitter.tweets  
     where rowid=@row_num);

     execute twitter.tokenize @string;

     set @row_num=@row_num+1;

end
end

execute twitter.split_sentence;

select token,count(*) as frequency
from  twitter.tokens
group by token
having count(*) >2
order by frequency desc;

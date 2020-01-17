CREATE SCHEMA IF NOT EXISTS usr;
create schema if not exists dd;
create schema if not exists typ;

drop table if exists dd.LnkUserQuestion;
drop table if exists typ.UserQuestionStatus;


drop table if exists dd.AnswerDetail;
drop table if exists dd.Answer;
drop table if exists typ.AnswerType;
drop table if exists dd.Question;
drop table if exists typ.QuestionType;
drop table if exists usr.LnkRoleAccessPermission;
drop table if exists usr.AccessPermission;
drop table if exists usr.User;
drop table if exists usr.Role;


create table if not exists usr.Role(
	Id int primary key not null,
	Name varchar(64) not null,
	Description varchar(256) not null,
	Active bit not null,
	CreatedOn timestamp not null,
	UpdatedOn timestamp not null,
	CreatedBy varchar(256) not null,
	UpdatedBy varchar(256) not null
);

create table if not exists usr.AccessPermission(
	Id int primary key not null,
	Name varchar(64) not null,
	Description varchar(256) not null,
	Active bit not null,
	CreatedOn timestamp not null,
	UpdatedOn timestamp not null,
	CreatedBy varchar(256) not null,
	UpdatedBy varchar(256) not null
);

create table if not exists usr.LnkRoleAccessPermission(
	Id serial primary key not null,
	RoleId int not null,
	AccessPermissionId int not null,
	Description varchar(256) not null,
	Active bit not null,
	CreatedOn timestamp not null,
	UpdatedOn timestamp not null,
	CreatedBy varchar(256) not null,
	UpdatedBy varchar(256) not null,
	constraint fk_LnkRoleAccessPermission_RoleId_Role_Id foreign key(RoleId) REFERENCES usr.Role (Id),
	constraint fk_LnkRoleAccessPermission_AccessPermissionId_AccessPermission_Id foreign key(AccessPermissionId) REFERENCES usr.AccessPermission (Id)
);

CREATE TABLE IF NOT EXISTS usr.User (
	Id UUID primary key not null,
	RoleId int not null,
	Email varchar(256) not null,
	HashedPassword varchar not null,
	PhoneNumber varchar(256) not null,
	Active bit not null,
	CreatedOn timestamp not null,
	UpdatedOn timestamp not null,
	CONSTRAINT ux_User_Email UNIQUE (Email),
	constraint fk_User_RoleId_Role_Id foreign key(RoleId) REFERENCES usr.Role (Id)
);

create table if not exists typ.QuestionType(
	Id int primary key not null,
	Name varchar(64) not null,
	Description varchar(256) not null,
	Active bit not null,
	CreatedOn timestamp not null,
	UpdatedOn timestamp not null,
	CreatedBy varchar(256) not null,
	UpdatedBy varchar(256) not null
);

insert into typ.QuestionType values
(1, 'NA', 'NA', B'1', current_timestamp, current_timestamp, '<setup>', '<setup>');

create table if not exists dd.Question(
	Id serial primary key not null,
	QuestionTypeId int not null,
	Description varchar not null,
	Active bit not null,
	CreatedOn timestamp not null,
	UpdatedOn timestamp not null,
	CreatedBy varchar(256) not null,
	UpdatedBy varchar(256) not null,
	constraint fk_Quesetion_QuestiontypeId_QuestionType_Id foreign key(QuestionTypeId) REFERENCES typ.QuestionType (Id)
);

create table if not exists typ.AnswerType(
	Id int not null primary key,
	Name varchar(64) not null,
	Description varchar(256) not null,
	Active bit not null,
	CreatedOn timestamp not null,
	UpdatedOn timestamp not null,
	CreatedBy varchar(256) not null,
	UpdatedBy varchar(256) not null
);
insert into typ.AnswerType values
(1, 'Code', 'Code', B'1', current_timestamp, current_timestamp, '<setup>', '<setup>');

create table if not exists dd.Answer(
	Id serial not null primary key,
	QuestionId int not null,
	Description varchar not null,
	Active bit not null,
	CreatedOn timestamp not null,
	UpdatedOn timestamp not null,
	CreatedBy varchar(256) not null,
	UpdatedBy varchar(256) not null,
	constraint fk_Answer_QuestionId_Question_Id foreign key(QuestionId) REFERENCES dd.Question (Id)
);
CREATE INDEX ix_Answer_QuestionId ON dd.Answer USING btree (QuestionId);

create table if not exists dd.AnswerDetail(
	Id serial not null primary key,
	AnswerId int not null,
	AnswerTypeId int not null,
	Description varchar not null,
	Active bit not null,
	CreatedOn timestamp not null,
	UpdatedOn timestamp not null,
	CreatedBy varchar(256) not null,
	UpdatedBy varchar(256) not null,
	constraint fk_Answer_AnswerId_Answer_Id foreign key(AnswerId) REFERENCES dd.Answer (Id),
	constraint fk_AnswerDetail_AnswerTypeId_AnswerType_Id foreign key(AnswerTypeId) REFERENCES typ.AnswerType (Id)
);
CREATE INDEX ix_AnswerDetail_AnswerId ON dd.AnswerDetail USING btree (AnswerId);

create table typ.UserQuestionStatus(
	Id int not null primary key,
	Name varchar(64) not null,
	Description varchar(256) not null,
	Active bit not null,
	CreatedOn timestamp not null,
	UpdatedOn timestamp not null,
	CreatedBy varchar(256) not null,
	UpdatedBy varchar(256) not null
);
insert into typ.UserQuestionStatus values
(1, 'Initial', 'Initial', B'1', current_timestamp, current_timestamp, '<setup>', '<setup>'),
(2, 'QuestionSent', 'Question Sent', B'1', current_timestamp, current_timestamp, '<setup>', '<setup>'),
(3, 'AnswerSent', 'Answer Sent', B'1', current_timestamp, current_timestamp, '<setup>', '<setup>');


create table if not exists dd.LnkUserQuestion(
	Id serial primary key not null,
	UserId UUID not null,
	QuestionId int not null,
	UserQuestionStatusId int not null,
	Description varchar(256) not null,
	Answered bit not null,
	Active bit not null,
	CreatedOn timestamp not null,
	UpdatedOn timestamp not null,
	CreatedBy varchar(256) not null,
	UpdatedBy varchar(256) not null,
	constraint fk_LnkUserQuestion_UserId_User_Id foreign key(UserId) REFERENCES usr.User (Id),
	constraint fk_LnkUserQuestion_QuestionId_Question_Id foreign key(QuestionId) REFERENCES dd.Question (Id),
	constraint fk_LnkUserQuestion_UserQuestionStatusId_UserQuestionStatus_Id foreign key(UserQuestionStatusId) REFERENCES typ.UserQuestionStatus (Id)
);

CREATE INDEX ix_LnkUserQuestion_UserId ON dd.LnkUserQuestion USING btree (UserId);
CREATE INDEX ix_LnkUserQuestion_QuestionId ON dd.LnkUserQuestion USING btree (QuestionId);

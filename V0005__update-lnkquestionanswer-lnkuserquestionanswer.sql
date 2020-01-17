CREATE SCHEMA IF NOT EXISTS usr;
create schema if not exists dd;
create schema if not exists typ;

drop table if exists dd.LnkUserQuestionAnswer;
drop table if exists dd.LnkQuestionAnswer;
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


create table if not exists usr.Role
(
    Id          int primary key not null,
    Name        varchar(64)     not null,
    Description varchar(256)    not null,
    Active      boolean             not null,
    CreatedOn   timestamp       not null,
    UpdatedOn   timestamp       not null,
    CreatedBy   varchar(256)    not null,
    UpdatedBy   varchar(256)    not null
);

create table if not exists usr.AccessPermission
(
    Id          int primary key not null,
    Name        varchar(64)     not null,
    Description varchar(256)    not null,
    Active      boolean             not null,
    CreatedOn   timestamp       not null,
    UpdatedOn   timestamp       not null,
    CreatedBy   varchar(256)    not null,
    UpdatedBy   varchar(256)    not null
);

create table if not exists usr.LnkRoleAccessPermission
(
    Id                 serial primary key not null,
    RoleId             int                not null,
    AccessPermissionId int                not null,
    Description        varchar(256)       not null,
    Active             boolean                not null,
    CreatedOn          timestamp          not null,
    UpdatedOn          timestamp          not null,
    CreatedBy          varchar(256)       not null,
    UpdatedBy          varchar(256)       not null,
    constraint fk_LRAP_RoleId_Role_Id foreign key (RoleId) REFERENCES usr.Role (Id),
    constraint fk_LRAP_AccessPermissionId_AccessPermission_Id foreign key (AccessPermissionId) REFERENCES usr.AccessPermission (Id)
);

CREATE TABLE IF NOT EXISTS usr.User
(
    Id             UUID primary key not null,
    RoleId         int              not null,
    Email          varchar(256)     not null,
    HashedPassword varchar          not null,
    PhoneNumber    varchar(256)     not null,
    Active         boolean              not null,
    CreatedOn      timestamp        not null,
    UpdatedOn      timestamp        not null,
    CreatedBy          varchar(256)       not null,
    UpdatedBy          varchar(256)       not null,
    CONSTRAINT ux_User_Email UNIQUE (Email),
    constraint fk_User_RoleId_Role_Id foreign key (RoleId) REFERENCES usr.Role (Id)
);

create table if not exists typ.QuestionType
(
    Id          int primary key not null,
    Name        varchar(64)     not null,
    Description varchar(256)    not null,
    Active      boolean             not null,
    CreatedOn   timestamp       not null,
    UpdatedOn   timestamp       not null,
    CreatedBy   varchar(256)    not null,
    UpdatedBy   varchar(256)    not null
);

insert into typ.QuestionType
values (1, 'NA', 'NA', TRUE, current_timestamp, current_timestamp, '<setup>', '<setup>');

create table if not exists dd.Question
(
    Id             serial primary key not null,
    QuestionTypeId int                not null,
    Description    varchar            not null,
    Active         boolean                not null,
    CreatedOn      timestamp          not null,
    UpdatedOn      timestamp          not null,
    CreatedBy      varchar(256)       not null,
    UpdatedBy      varchar(256)       not null,
    constraint fk_Quesetion_QuestiontypeId_QuestionType_Id foreign key (QuestionTypeId) REFERENCES typ.QuestionType (Id)
);

create table if not exists typ.AnswerType
(
    Id          int          not null primary key,
    Name        varchar(64)  not null,
    Description varchar(256) not null,
    Active      boolean          not null,
    CreatedOn   timestamp    not null,
    UpdatedOn   timestamp    not null,
    CreatedBy   varchar(256) not null,
    UpdatedBy   varchar(256) not null
);
insert into typ.AnswerType
values (1, 'Code', 'Code', TRUE, current_timestamp, current_timestamp, '<setup>', '<setup>');

create table if not exists dd.Answer
(
    Id          serial       not null primary key,
    Description varchar      not null,
    Active      boolean          not null,
    CreatedOn   timestamp    not null,
    UpdatedOn   timestamp    not null,
    CreatedBy   varchar(256) not null,
    UpdatedBy   varchar(256) not null
);


create table if not exists dd.AnswerDetail
(
    Id           serial       not null primary key,
    AnswerId     int          not null,
    AnswerTypeId int          not null,
    Description  varchar      not null,
    Active       boolean          not null,
    CreatedOn    timestamp    not null,
    UpdatedOn    timestamp    not null,
    CreatedBy    varchar(256) not null,
    UpdatedBy    varchar(256) not null,
    constraint fk_Answer_AnswerId_Answer_Id foreign key (AnswerId) REFERENCES dd.Answer (Id),
    constraint fk_AnswerDetail_AnswerTypeId_AnswerType_Id foreign key (AnswerTypeId) REFERENCES typ.AnswerType (Id)
);
CREATE INDEX ix_AnswerDetail_AnswerId ON dd.AnswerDetail USING btree (AnswerId);

create table typ.UserQuestionStatus
(
    Id          int          not null primary key,
    Name        varchar(64)  not null,
    Description varchar(256) not null,
    Active      boolean          not null,
    CreatedOn   timestamp    not null,
    UpdatedOn   timestamp    not null,
    CreatedBy   varchar(256) not null,
    UpdatedBy   varchar(256) not null
);
insert into typ.UserQuestionStatus
values (1, 'Initial', 'Initial', TRUE, current_timestamp, current_timestamp, '<setup>', '<setup>'),
       (2, 'QuestionSent', 'Question Sent', TRUE, current_timestamp, current_timestamp, '<setup>', '<setup>'),
       (3, 'AnswerSent', 'Answer Sent', TRUE, current_timestamp, current_timestamp, '<setup>', '<setup>');

create table if not exists dd.LnkQuestionAnswer
(
	Id			UUID			not null primary key,
	QuestionId 	int				not null,
	AnswerId	int				not null,
	Description	varchar(256)	not null,
	Active      boolean         not null,
    CreatedOn   timestamp       not null,
    UpdatedOn   timestamp       not null,
    CreatedBy   varchar(256)    not null,
    UpdatedBy   varchar(256)    not null,
	constraint fk_LnkQuestionAnswer_QuestionId_Question_Id foreign key (QuestionId) REFERENCES dd.Question (Id),
	constraint fk_LnkQuestionAnswer_AnswerId_Question_Id foreign key (AnswerId) REFERENCES dd.Answer (Id)
);

create table if not exists dd.LnkUserQuestionAnswer
(
    Id                   serial primary key not null,
    UserId               UUID               not null,
    LnkQuestionAnswerId  UUID               not null,
    UserQuestionStatusId int                not null,
    Description          varchar(256)       not null,
	QuestionOrder		 int				not null,
    Active               boolean            not null,
    CreatedOn            timestamp          not null,
    UpdatedOn            timestamp          not null,
    CreatedBy            varchar(256)       not null,
    UpdatedBy            varchar(256)       not null,
	CONSTRAINT ux_LnkUserQuestionAnswer_UserId_LnkQuestionAnswerId UNIQUE (UserId, LnkQuestionAnswerId),
    constraint fk_LUQA_UserId_User_Id foreign key (UserId) REFERENCES usr.User (Id),
    constraint fk_LUQA_LnkQuestionAnswerId_LnkQuestionAnswer_Id foreign key (LnkQuestionAnswerId) REFERENCES dd.LnkQuestionAnswer (id),
    constraint fk_LUQA_UserQuestionStatusId_UserQuestionStatus_Id foreign key (UserQuestionStatusId) REFERENCES typ.UserQuestionStatus (Id)
);

CREATE INDEX ix_LnkUserQuestionAnswer_UserId ON dd.LnkUserQuestionAnswer USING btree (UserId);
CREATE INDEX ix_LnkUserQuestionAnswer_UserId_QuestionOrder ON dd.LnkUserQuestionAnswer USING btree (UserId, QuestionOrder);
CREATE INDEX ix_LnkUserQuestionAnswer_LnkQuestionAnswerId ON dd.LnkUserQuestionAnswer USING btree (LnkQuestionAnswerId);

insert into usr.Role
values (1, 'admin', 'Admin user', TRUE, current_timestamp, current_timestamp, '<setup>', '<setup>'),
       (2, 'user', 'Normal user', TRUE, current_timestamp, current_timestamp, '<setup>', '<setup>');

insert into usr.User values
('2bed5741-f8a0-4999-9349-0468939a974f',1,'light_1986@msn.com','$2a$10$XWP2Paj4W.vgagYEVVXlGOAw7CMpMeNWaomsWnFihtCuoiRz6PO8W','15201745239',true,current_timestamp,current_timestamp,'<setup>','<setup>');

insert into dd.Question values(
1, 1,'给定一个数字列表和一个数字k，返回列表中是否有两个数字加起来等于k。
例如，给定[10、15、3、7]和k为17，因为10 + 7为17，所以返回true。
奖励：你能一口气做到吗',true,current_timestamp,current_timestamp,'<setup>','<setup>'
);

insert into typ.AnswerType values
(2,'Paragraph','Paragraph',true,current_timestamp,current_timestamp,'<setup>','<setup>'),
(3,'BulletPoint','Bullet Point',true,current_timestamp,current_timestamp,'<setup>','<setup>');

insert into dd.Answer values(
1,'',true,current_timestamp,current_timestamp,'<setup>','<setup>');


insert into dd.AnswerDetail values
(1,1,2,'
这个问题可以通过几种不同的方式解决。
蛮力方式将涉及嵌套迭代以检查每对数字：',true,current_timestamp,current_timestamp,'<setup>','<setup>'),
(2,1,1,'def two_sum(lst, k):
    for i in range(len(lst)):
        for j in range(len(lst)):
            if i != j and lst[i] + lst[j] == k:
                return True
  return False',true,current_timestamp,current_timestamp,'<setup>','<setup>'),
(3,1,2,'
这将花费O（N2）。另一种方法是使用一组记忆我们到目前为止所看到的数字。然后，对于给定的数字，我们可以检查是否存在另一个数字，如果相加，该数字将加起来为k。这将是O（N），因为集合的查找每个都是O（1）。',true,current_timestamp,current_timestamp,'<setup>','<setup>'),
(4,1,1,'def two_sum(lst, k):
    seen = set()
    for num in lst:
        if k - num in seen:
            return True
        seen.add(num)
    return False',true,current_timestamp,current_timestamp,'<setup>','<setup>'),
(5,1,2,'另一解决方案涉及对列表进行排序。然后，我们可以遍历列表并在K-lst [i]上运行二进制搜索。由于我们对N个元素运行二进制搜索，因此将占用O（N log N）和O（1）空间。',true,current_timestamp,current_timestamp,'<setup>','<setup>'),
(6,1,1,'from bisect import bisect_left

def two_sum(lst, K):
    lst.sort()

    for i in range(len(lst)):
        target = K - lst[i]
        j = binary_search(lst, target)

        # Check that binary search found the target and that it''s not in the same index
        # as i. If it is in the same index, we can check lst[i + 1] and lst[i - 1] to see
        #  if there''s another number that''s the same value as lst[i].
        if j == -1:
            continue
        elif j != i:
            return True
        elif j + 1 < len(lst) and lst[j + 1] == target:
            return True
        elif j - 1 >= 0 and lst[j - 1] == target:
            return True
    return False

def binary_search(lst, target):
    lo = 0
    hi = len(lst)
    ind = bisect_left(lst, target, lo, hi)

    if 0 <= ind < hi and lst[ind] == target:
        return ind
    return -1',true,current_timestamp,current_timestamp,'<setup>','<setup>');


insert into dd.LnkQuestionAnswer values
('247c136c-64bc-a9b2-4f63-1d00680b092c',1,1,'',true,current_timestamp,current_timestamp,'<setup>','<setup>');



insert into dd.LnkUserQuestionAnswer values
(1,'2bed5741-f8a0-4999-9349-0468939a974f','247c136c-64bc-a9b2-4f63-1d00680b092c',3,'',1,true,current_timestamp,current_timestamp,'<setup>','<setup>');








insert into dd.Question values(
2, 1,'已知：
1.一组整数数组

问：
1. 返回一个新书组A
2. A的任意索引出i， i的值为原数组除i位置以外所有数的乘积

例：
1. 输入[1,2,3,4,5] => 输出 [120,60,40,30,24]
2. 输入[3,2,1] => 输出 [2,3,6]

附加：
如果不能使用除法怎么办？'
	,true,current_timestamp,current_timestamp,'<setup>','<setup>'
);

insert into dd.Answer values(
2,'',true,current_timestamp,current_timestamp,'<setup>','<setup>');



insert into dd.AnswerDetail values
(7,2,2,'使用除法：
1 计算原数组所有数字的乘积
2 用乘积除以每个索引位置的数值',true,current_timestamp,current_timestamp,'<setup>','<setup>'),
(8,2,2,'不使用除法：
对于任意索引i，我们可以
1 找到索引i之前所有数字的乘积
2 找到索引之后所以数字的乘积
3 "之前"与"之后"相乘',true,current_timestamp,current_timestamp,'<setup>','<setup>'),
(9,2,2,'所以，我们可以提前计算所有之前和之后的乘积。
在真正计算的时候，每个索引除只需查询就可找到"之前"和"之后"，然后两者相乘即为答案。',true,current_timestamp,current_timestamp,'<setup>','<setup>'),
(10,2,1,'def products(nums):

    # Generate before products
    beforeProducts = []
    for num in nums:
        if beforeProducts:
            beforeProducts.append(beforeProducts[-1] * num)
        else:
            beforeProducts.append(num)

    # Generate after products
    afterProducts = []
    for num in reversed(nums):
        if afterProducts:
            afterProducts.append(afterProducts[-1] * num)
        else:
            afterProducts.append(num)
    afterProducts = list(reversed(afterProducts))

    # Generate result
    result = []
    for i in range(len(nums)):
        if i == 0:
            result.append(afterProducts[i + 1])
        elif i == len(nums) - 1:
            result.append(beforeProducts[i - 1])
        else:
            result.append(beforeProducts[i - 1] * afterProducts[i + 1])
    return result',true,current_timestamp,current_timestamp,'<setup>','<setup>');


insert into dd.LnkQuestionAnswer values
('e339b410-f693-22fb-2a06-e8211531a426',2,2,'',true,current_timestamp,current_timestamp,'<setup>','<setup>');



insert into dd.LnkUserQuestionAnswer values
(2,'2bed5741-f8a0-4999-9349-0468939a974f','e339b410-f693-22fb-2a06-e8211531a426',3,'',2,true,current_timestamp,current_timestamp,'<setup>','<setup>');




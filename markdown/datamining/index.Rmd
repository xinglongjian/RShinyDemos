主要介绍如何使用R进行数据挖掘
========================================================

这里主要介绍数据挖掘过程和常用的技术，包含聚类、分类和关联规则。也展示了用于数据挖掘的R包以及数据集。每一种技术可以有多种方式实现，我会一一加入进来，尽量描述数据挖掘的整个过程。

1、数据挖掘的主要技术
--------------------------------------------------------
* 聚类(Clustering)
* 分类(Classificating)
* 关联规则(Association Rules)
* 序列模式(Sequential Patterns)
* 时序分析(Time Series Analysis)
* 文本挖掘(Text Mining)

2、数据挖掘用到的包和函数
--------------------------------------------------------
下面罗列了一些用于数据挖掘的包，并没有全部使用过，也会有遗漏，会不断更新。

### 聚类

* 包：fpc,cluster,pvclust,mclust
* 基于分片的聚类：kmeans,pam,pamk,clara
* 层次聚类：hclust,pvclust,agnes,diana
* 基于密度的聚类：mclust
* 绘制集群解决方案：plotcluster,plot,hclust
* 验证集群解决方案：cluster.stats

### 分类

* 包：rpart,party,randomForest,rpartOrdinal,tree,marginTree,maptree,survival
* 决策树：rpart,ctree
* 随机森林：cforest,randomForest
* 逻辑回归：logistic，
* 泊松回归：glm,predict,residuals
* 生存分析：survfit,survdiff,coxph

### 关联规则和频繁项集

* 包：arules,drm
* APRIORI算法：apriori,drm
* ECLAT算法：eclat

### 序列模型

* 包：arulesSequences
* SPADE算法：cSPADE

### 时序

* 包：timsac
* 构造时序序列：ts
* 分解：decomp,decompose,stl,tsr

### 统计

* 包：base R,nlme
* 变量分析：aov,anova
* 密度分析：density
* 统计测试：t.test,prop.test,anova,aov
* 线性混合效应模型拟合：lme
* 主成分和因子分析：princomp

### 图形

* bar图：barplot
* pie图：pie
* 散点图：dotchart
* 柱状图： hist
* 密度图：densityplot
* 箱线图：boxplot
* qq图：qqnorm,qqnplot,qqline
* 双变量图：coplot
* 树：rpart
* 平行坐标：parallel,paracoor,parcoord
* 热点、轮廓：contour，filled,contour
* 其他图：stripplot,sunflowerplot,interaction.plot,matplot,fourfoldplot,assocplot,mosaicplot
* 保存图形格式：pdf,postscript,win.metafile,jpeg,bmp,png

### 数据管理

* 缺失值：na.omit
* 标准化变量：scale
* 转换：t
* 样例：sample
* 栈：stack,unstack
* 其他：aggregate,merge,reshape

3、数据集
-----------------------------------------------------
### Iris数据集
str(iris)

### mboost包中的bodyfat数据集
data("bodyfat",package="mboost")






脚本提供一个自动化流程，用于：

从 symbol id 批量查询 UniProt 数据库，获取对应的 UniProt 登录号（Accession）。

基于登录号，分别获取每个蛋白质的 蛋白质家族（Protein families）和 超家族（SUPERFAMILY） 信息。

将结果合并为一张表格，输出为 CSV 文件，方便下游分析。

主要应用场景：蛋白质家族分类
---
layout: post
title: "Fork/Join的一次实践"
excerpt: "一些java多线程相关实践"
categories: [java]
commnet: true
---

# 摘抄一些简介
Fork/Join 框架是 Java7 提供了的一个用于并行执行任务的框架， 是一个把大任务分割成若干个小任务，最终汇总每个小任务结果后得到大任务结果的框架。

其框架有一个特点：**任务窃取算法**，任务窃取算法会多消耗一点资源，但是它让每个线程都不会闲着，我对此还是十分欢喜的。  

更多介绍见[https://www.infoq.cn/article/fork-join-introduction](https://www.infoq.cn/article/fork-join-introduction)

# 这次实践的任务
系统会从数据库里一批一批的查数据，一批数据20条，每一条要经过一个`boolean ruleCheck(Integer projectId)`服务的检查。为了效率，必须得用多线程，不然rpc服务就超时了。

# 使用Fork/Join注意事项
- **一定要先把所有任务分出来，再去计算，合并结果。不要挤牙膏。** 这也就是为什么网上示例代码都是对半分割任务。
举个例子：原先我计算任务是挤牙膏式的（当时还是没深入理解）

- fork/join适合CPU密集型任务，我本次任务应该属于IO密集型，所以之后就用线程池自己写了。

```java
class ProjectCheckTask extends Recursive<Boolean> {
    // 保存需要检查的项目ID
    private List<Integer> allProjectIds;
    // 计算的项目ID
    private Integer targetProjectId;

    public ProjectCheckTask(Integer targetProjectId, List<Integer> projectIds) {
        // set allProjectIds, targetProjectId
    }

    protected Boolean compute() {
        // 这里的代码并不完整，还有一些分支情况是计算还是继续切割任务就不列出来了
        // 主要看下 else 代码里的分任务代码，即：挤牙膏式分割
        if (targetProjectId != null) {
            // 如果计算的项目ID不为空，即可调用服务，进行具体的业务计算
            abcService.ruleCheck(targetProjectId);
        } else {
            // 任务不够小，分割任务
            // 取头一个projectId，leftTask就会进行业务计算
            ProjectCheckTask leftTask = new ProjectCheckTask(allProjectIds.get(0), null);
            // 将剩下来的projectIds分给rightTask，rightTask就会继续分割下去
            ProjectCheckTask rightTask = new ProjectCheckTask(null, allProjectIds.subList(1, allProjectIds.size()-1))
            invokeAll(leftTask, rightTask);
        }
    }
}   
```

**所以上面这种挤牙膏式的分任务方式，导致你的效率提升的倍数跟你挤牙膏的速度有关，所以即使你定义8个线程，定义16个线程，最后你发现，你效率始终都只能提升2倍～因为你永远有一个线程在挤牙膏，挤出来一个牙膏就被一个线程消费了，所以自始至终你活跃的线程也就2，3个**

所以正确的Fork/Join使用姿势应该是线程一开始都在分任务，任务全分完了，然后大家再噼里啪啦全力计算任务。就像下面这样：

```java
    protected Boolean compute() {
        // 这里的代码并不完整，还有一些分支情况是计算还是继续切割任务就不列出来了
        // 主要看下 else 代码里的分任务代码，即：挤牙膏式分割
        if (targetProjectId != null) {
            // 如果计算的项目ID不为空，即可调用服务，进行具体的业务计算
            abcService.ruleCheck(targetProjectId);
        } else {
            // 之前的挤牙膏式
            //ProjectCheckTask leftTask = new ProjectCheckTask(allProjectIds.get(0), null);
            //ProjectCheckTask rightTask = new ProjectCheckTask(null, allProjectIds.subList(1, allProjectIds.size()-1))

            // 一次性分完
            List<ProjectCheckTask> tasks = allProjectIds.stream().map(id -> new ProjectCheckTask(id, null)).collect(Collectors.toList());

            invokeAll(tasks);
        }
    }
```

# 疑问
1. `ForkJoinTask.invokeAll()`和`for(){task.fork()} for(){task.join()}`的activeThreadCount?

通过`invokeAll`方法执行任务，`pool.getActiveThreadCount()`与`pool.getParallelism()`始终保持一致。  

但是通过`for() {task.fork()} for() {task.join()}`方式执行的任务，`pool.getActiveThreadCount()`会超过`pool.getParallelism()`定义的并行数。  

难道是因为补偿机制？
> Compensating-补偿运行：如果没有足够的活动线程，tryCompensate()可能创建或重新激活一个备用的线程来为被阻塞的 joiner 补偿运行。  
> [JUC源码分析-线程池篇（四）：ForkJoinPool - 1](https://www.jianshu.com/p/32a15ef2f1bf)

相关文章：[https://www.liaoxuefeng.com/article/001493522711597674607c7f4f346628a76145477e2ff82000](https://www.liaoxuefeng.com/article/001493522711597674607c7f4f346628a76145477e2ff82000)


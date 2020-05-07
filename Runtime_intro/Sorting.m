//
//  Sorting.m
//  Runtime_intro
//  
//  Created by ash on 2020/5/6.
//  Copyright © 2020 ash. All rights reserved.
//
    

#import "Sorting.h"

#define EXCHANGE(num1, num2) \
{\
    num1 = num1 ^ num2;\
    num2 = num1 ^ num2;\
    num1 = num1 ^ num2;\
}

@implementation Sorting


//一.冒泡排序
//冒泡排序原理很容易理解，就是重复地走访过要排序的元素列，依次比较两个相邻的元素，顺序不对就交换，直至没有相邻元素需要交换，也就是排序完成。
//这个算法的名字由来是因为越大的元素会经由交换慢慢“浮”到数列的顶端（升序或降序排列），就如同碳酸饮料中二氧化碳的气泡最终会上浮到顶端一样，故名“冒泡排序”。

//冒泡排序是一种稳定排序算法。
//时间复杂度:最好情况(初始情况就是正序)下是o(n),平均情况是o(n²)

void buddleSort(int num[], int count)
{
    for (int i = 0; i < count - 1; i++) {
        for (int j = 0; j < count - i - 1; j++) {
            if (num[j] > num[j + 1]) {
                EXCHANGE(num[j], num[j + 1])
            }
        }
    }
}

//二、选择排序
//选择排序（Selection sort）是一种简单直观的排序算法。
//它的工作原理是每一次从待排序的数据元素中选出最小（或最大）的一个元素，存放在序列的起始位置，
//然后，再从剩余未排序元素中继续寻找最小（大）元素，然后放到已排序序列的末尾。以此类推，直到全部待排序的数据元素排完。
//选择排序的交换操作介于 0 和 (n - 1） 次之间。选择排序的比较操作为 n (n - 1） / 2 次之间。
//选择排序的赋值操作介于 0 和 3 (n - 1） 次之间。
//比较次数O(n²），比较次数与关键字的初始状态无关，总的比较次数N=(n-1）+(n-2）+...+1=n*(n-1）/2。
//交换次数O(n），最好情况是，已经有序，交换0次；
//最坏情况交换n-1次，逆序交换n/2次。
//交换次数比冒泡排序少多了，由于交换所需CPU时间比比较所需的CPU时间多，n值较小时，选择排序比冒泡排序快

void selectSort(int num[], int count)
{
    for (int i = 0; i < count; i++) {
        int min = i;
        for (int j = i; j < count; j++) {
            if (num[j] < num[min]) {
                min = j;
            }
        }
        if (i != min) {
            EXCHANGE(num[i], num[min]);//可以看出，最多交换count - 1次
        }
    }
}
// 987654321

//三、直接插入排序
//插入排序的基本操作就是将一个数据插入到已经排好序的有序数据中，
//从而得到一个新的、个数加一的有序数据，算法适用于少量数据的排序，
//插入排序的基本思想是：每步将一个待排序的记录，按其关键码值的大小插入前面已经排序的文件中适当位置上，直到全部插入完为止

//直接插入排序是稳定的排序算法。
//时间复杂度：最好情况(初始情况就是正序)下是o(n),平均情况是o(n²)

void insertSort2(int num[], int count)
{
    int i,j;
    for (i = 1; i < count; i++) {
        if (num[i] < num[i - 1]) {
            int temp = num[i];
            for (j = i; j > 0; j--) {
                if (num[j - 1] > temp) {
                    num[j] = num[j - 1];
                }else {
                    break;
                }
            }
            num[j] = temp;
        }
    }
}

//四、二分插入排序
//由于在插入排序过程中，待插入数据左边的序列总是有序的，
//针对有序序列，就可以用二分法去插入数据了，也就是二分插入排序法。适用于数据量比较大的情况。

//算法的基本过程：
//（1）计算 0 ~ i-1 的中间点，用 i 索引处的元素与中间值进行比较，如果 i 索引处的元素大，说明要插入的这个元素应该在中间值和刚加入i索引之间，反之，就是在刚开始的位置 到中间值的位置，这样很简单的完成了折半；
//（2）在相应的半个范围里面找插入的位置时，不断的用（1）步骤缩小范围，不停的折半，范围依次缩小为 1/2 1/4 1/8 .......快速的确定出第 i 个元素要插在什么地方；
//（3）确定位置之后，将整个序列后移，并将元素插入到相应位置。

void insertSortBinary(int num[],int count)
{
    int i,j;
    for (i = 0; i < count; i ++) {
        if (num[i] < num[i - 1]) {
            int temp = num[i];
            int left = 0,right = i - 1;
            
            while (left <= right) {
                int mid = (left + right)/2;
                if (num[mid] < temp) {
                    left = mid + 1;
                }else {
                    right = mid - 1;
                }
            }
            //只是比较次数变少了，交换次数还是一样的
            for (j = i; j > left; j--) {
                num[j] = num[j - 1];
            }
            
            num[left] = temp;
        }
    }
}

//五、希尔(插入)排序
//希尔排序(Shell's Sort)是插入排序的一种又称“缩小增量排序”（Diminishing Increment Sort），是直接插入排序算法的一种更高效的改进版本。
//希尔排序是把记录按下标的一定增量分组，对每组使用直接插入排序算法排序；随着增量逐渐减少，每组包含的关键词越来越多，当增量减至1时，整个文件恰被分成一组，排序完成。
//希尔排序是非稳定排序算法。
//时间复杂度：O(n^（1.3—2）)

void shellSort(int num[],int count)
{
    int shellNum = 2;
    int gap = round(count/shellNum);
    
    while (gap > 0) {
        for (int i = gap; i < count; i ++) {
            int temp = num[i];
            int j = i;
            while (j >= gap && num[j - gap] > temp) {
                num[j] = num[j - gap];
                j = j - gap;
            }
            num[j] = temp;
        }
        gap = round(gap/shellNum);
    }
}

//六、快速排序
//快速排序（Quicksort）是对冒泡排序的一种改进。
//
//它的基本思想是：通过一趟排序将要排序的数据分割成独立的两部分，其中一部分的所有数据都比另外一部分的所有数据都要小，
//然后再按此方法对这两部分数据分别进行快速排序，整个排序过程可以递归进行，以此达到整个数据变成有序序列。

//快速排序是非稳定的排序算法
//时间复杂度：最差为O(n^2)，平均为O(nlogn)，最好为O(nlogn)

void quickSort(int num[],int count,int left,int right)
{
    if (left >= right){
        return;
    }
    
    int key = num[left];
    int lp = left;           //左指针
    int rp = right;          //右指针
    while (lp < rp) {
        if (num[rp] < key) {
            int temp = num[rp];
            for (int i = rp - 1; i >= lp; i--) {
                num[i + 1] = num[i];
            }
            num[lp] = temp;
            lp ++;
            rp ++;
        }
        rp --;
    }
    quickSort(num,count,left,lp - 1);
    quickSort(num,count,rp + 1,right);
    
}

//七、堆排序
//是指利用堆这种数据结构所设计的一种排序算法。
//堆是一个近似完全二叉树的结构
//并同时满足堆积的性质：即子结点的键值或索引总是小于（或者大于）它的父节点

//最大堆调整（Max Heapify）：将堆的末端子节点作调整，使得子节点永远小于父节点
//创建最大堆（Build Max Heap）：将堆中的所有数据重新排序
//堆排序（HeapSort）：移除位在第一个数据的根节点，并做最大堆调整的递归运算

//堆排序是一个非稳定的排序算法。
//时间复杂度：O(nlogn)

void maxHeapify(int num[], int start, int end)
{
    //建立父节点指标和子节点指标
    int dad = start;
    int son = dad * 2 + 1;
    
    while (son <= end) { //若子节点指标在范围内才做比较
        if (son + 1 <= end && num[son] < num[son + 1]) //先比较两个子节点大小，选择最大的
            son++;
        if (num[dad] > num[son]) //如果父节点大於子节点代表调整完毕，直接跳出函数
            return;
        else { //否则交换父子内容再继续子节点和孙节点比较
            EXCHANGE(num[dad], num[son])
            dad = son;
            son = dad * 2 + 1;
        }
    }
}

void heapSort(int num[], int count)
{
    int i;
    //初始化，i从最後一个父节点开始调整
    for (i = count / 2 - 1; i >= 0; i--)
        maxHeapify(num, i, count - 1);
    //先将第一个元素和已排好元素前一位做交换，再重新调整，直到排序完毕
    for (i = count - 1; i > 0; i--) {
        EXCHANGE(num[0], num[i])
        maxHeapify(num, 0, i - 1);
    }
}

@end

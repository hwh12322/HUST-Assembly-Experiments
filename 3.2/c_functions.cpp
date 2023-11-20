#include<stdio.h>
#include<string.h>
#pragma pack(1)
struct sample {
	char name[7];
	int A, B, C, F;
};

extern "C" void pastedata(sample* ss) {
	sample* cls = (sample*)ss;
	printf_s("请输入新数据：\n");
	scanf_s("%s", cls->name, 7);
	scanf_s("%d%d%d", &(cls->A), &(cls->B), &(cls->C));
}

extern "C" void exitornot(sample* ss, int* n) {
	char ch;
	getchar();
	printf_s("请输入你的选择：q/r/m\n");
	scanf_s("%c", &ch, 1);
	switch(ch) {
	case 'q':
		*n = 0;
		break;
	case 'r':
		*n = 1;
		break;
	case 'm':
		pastedata(ss);
		*n = -1;
		break;
	default:
		*n = -1;
		break;
	}
}

extern "C" void printMID(sample* ss, int n) {
	n /= 23;
	for (int i = 0; i < n; i++) {
		printf("SAMID: %s\n", ss[i].name);
		printf("SDA: %d\n", ss[i].A);
		printf("SDB: %d\n", ss[i].B);
		printf("SDC: %d\n", ss[i].C);
		printf("SF: %d\n\n", ss[i].F);
	}
}

extern "C" void compare(char* v1, char* v2, int* n) {
	for (int i = 0; i < 3; i++) {
		printf_s("请输入用户名和密码：\n");
		scanf_s("%s%s", v1, 11, v2, 11);
		int a = strcmp(v1, "114514");
		int b = strcmp(v2, "1919810");
		if (a == 0 && b == 0) {
			*n = 1;
			return;
		}
		printf_s("用户名或者密码错误！\n");
	}
	*n = 0;
}
#include <stdio.h>
#include <stdlib.h>

#define SAMPLE_FILE_PATH "../sample.txt"
#define INPUT_FILE_PATH "../input.txt"

typedef struct input {
  int *vals;
  int bit_length;
  int size;
} Input;

int get_line_count(char *path) {
  FILE *f_lines = fopen(path, "r");

  int line_count = 0;

  int has_ch = 0;

  char ch;
  char last_ch;

  do {
    if (has_ch) {
      last_ch = ch;
    }

    ch = fgetc(f_lines);

    if (ch == '\n') {
      line_count++;
    }

    if (!has_ch) {
      has_ch = 1;
    }
  } while (ch != EOF);

  if (last_ch != '\n') {
    line_count++;
  }

  fclose(f_lines);

  return line_count;
}

void get_input_from_file(char *path, int *lines) {
  FILE *f = fopen(path, "r");

  char *line = NULL;
  size_t len = 0;
  ssize_t read;
  int line_count = 0;

  while ((read = getline(&line, &len, f)) != -1) {
    int number_from_line = strtol(line, NULL, 2);
    lines[line_count++] = number_from_line;
  }

  if (line) {
    free(line);
  }

  fclose(f);
}

int get_bit_length(int val) {
  int bit_len = 0;

  while (val > 0) {
    bit_len++;
    val = val >> 1;
  }

  return bit_len;
}

int get_max_bit_length(int *vals, int size) {
  int max = 0;

  for (int i = 0; i < size; i++) {
    int len = get_bit_length(vals[i]);

    if (len > max) {
      max = len;
    }
  }

  return max;
}

int find_max_val(int *vals, int size) {
  int max = 0;

  for (int i = 0; i < size; i++) {
    int val = vals[i];

    if (val > max) {
      max = val;
    }
  }

  return max;
}

void get_bit_count(int *bit_list, int bit_list_size, int bit_length,
                   int *bit_count) {
  for (int i = 0; i < bit_length; i++) {
    bit_count[i] = 0;
  }

  for (int i = 0; i < bit_list_size; i++) {
    int val = bit_list[i];
    int c = 0;

    while (val > 0) {
      int bit = val % 2;

      if (bit) {
        bit_count[c]++;
      }

      c++;
      val = val >> 1;
    }
  }
}

int find_gamma(Input input) {
  int *bit_count = malloc(sizeof(int) * input.bit_length);
  get_bit_count(input.vals, input.size, input.bit_length, bit_count);

  int gamma = 0;

  for (int i = input.bit_length - 1; i >= 0; i--) {
    int count = bit_count[i];

    if (count > (input.size / 2)) {
      gamma++;
    }

    if (i > 0) {
      gamma = gamma << 1;
    }
  }

  free(bit_count);

  return gamma;
}

int find_epsilon(Input input) {
  int *bit_count = malloc(sizeof(int) * input.bit_length);
  get_bit_count(input.vals, input.size, input.bit_length, bit_count);

  int epsilon = 0;

  for (int i = input.bit_length - 1; i >= 0; i--) {
    int count = bit_count[i];

    if (count < (input.size / 2)) {
      epsilon++;
    }

    if (i > 0) {
      epsilon = epsilon << 1;
    }
  }

  free(bit_count);

  return epsilon;
}

int get_bit_at_position(int val, int position) { return (val >> position) % 2; }

int find_generator_rating(Input input) {
  int *bit_count = malloc(sizeof(int) * input.bit_length);
  get_bit_count(input.vals, input.size, input.bit_length, bit_count);

  int *int_list = malloc(sizeof(int) * input.size);
  int int_list_size = 0;
  int int_count = input.size;

  for (int i = input.bit_length - 1; i >= 0; i--) {
    int count = bit_count[i];

    for (int j = 0; j < int_count; j++) {
      int val;
      if (i < input.bit_length - 1) {
        val = int_list[j];
      } else {
        val = input.vals[j];
      }

      /* printf("count/int_count %d/%d\n", count, int_count); */
      if (count >= (int_count / 2)) {
        if (get_bit_at_position(val, i) == 1) {
          int_list[int_list_size++] = val;
        }
      } else {
        if (get_bit_at_position(val, i) == 0) {
          int_list[int_list_size++] = val;
        }
      }
    }

    printf("pos/count/size %d/%d/%d\n", i, int_count, int_list_size);

    printf("----------int_list----------\n");

    for (int i = 0; i < int_list_size; i++) {
      printf("int_list[i = %d] %d\n", i, int_list[i]);
    }

    int_count = int_list_size;
    int_list_size = 0;

    printf("----------bit_list----------\n");

    for (int i = 0; i < input.bit_length; i++) {
      printf("bit_list[i = %d] %d\n", i, bit_count[i]);
    }

    get_bit_count(int_list, int_count, input.bit_length, bit_count);
  }

  free(bit_count);
  int ret = int_list[0];
  free(int_list);
  return ret;
}

int find_scrubber_rating(Input input) {
  int *bit_count = malloc(sizeof(int) * input.bit_length);
  get_bit_count(input.vals, input.size, input.bit_length, bit_count);

  int *int_list = malloc(sizeof(int) * input.size);
  int int_list_size = 0;
  int int_count = input.size;

  int threshold = input.size / 2;

  for (int i = input.bit_length - 1; i > 0; i--) {
    int count = bit_count[i];

    for (int j = 0; j < int_count; j++) {
      int val;
      if (i != input.bit_length - 1) {
        val = int_list[j];
      } else {
        val = input.vals[j];
      }

      if (count <= threshold) {
        if (get_bit_at_position(val, i) == 0) {
          int_list[int_list_size++] = val;
        }
      } else {
        if (get_bit_at_position(val, i) == 1) {
          int_list[int_list_size++] = val;
        }
      }
    }

    int_count = int_list_size;
    int_list_size = 0;
  }

  free(bit_count);
  int ret = int_list[0];
  free(int_list);
  return ret;
}

int get_bit_count_for_position(int *input, int position, int size) {
  int count = 0;

  for (int i = 0; i < size; i++) {
    int val = input[i];

    if ((val >> (position - 1)) % 2) {
      count++;
    }
  }

  return count;
}

Input get_data_from_file(char *path) {
  Input i;

  int input_size = get_line_count(path);
  i.size = input_size;

  int *rows = malloc(sizeof(int) * input_size);
  get_input_from_file(path, rows);

  i.vals = rows;
  i.bit_length = get_max_bit_length(rows, input_size);

  return i;
}

int solve(char *path) {
  Input input = get_data_from_file(path);
  int gamma = find_gamma(input);
  int epsilon = find_epsilon(input);

  return gamma * epsilon;
}

int solve2(char *path) {
  Input input = get_data_from_file(path);
  int generator = find_generator_rating(input);
  int scrubber = find_scrubber_rating(input);

  printf("generator %d\n", generator);
  printf("scrubber: %d\n", scrubber);

  return generator * scrubber;
}

int main() {
  int part1_sample = solve(SAMPLE_FILE_PATH);
  printf("sample:\t %d\n", part1_sample);

  int part1 = solve(INPUT_FILE_PATH);
  printf("part 1:\t %d\n", part1);

  printf("generator: %d", solve2(SAMPLE_FILE_PATH));

  return 0;
}

create type program_type as enum ('BS', 'BA', 'BFA', 'BArch', 'BLA')
create type requisite_type as enum ('prerequisite', 'corequisite', 'recommended', 'concurrent')

create table
  public.ge_areas (
    area text not null,
    name text not null,
    constraint ge_areas_pkey primary key (area)
  ) tablespace pg_default;

create table
  public.course_sets (
    set_number integer not null,
    constraint course_sets_pkey primary key (set_number)
  ) tablespace pg_default;

create table
  public.ge_subareas (
    subarea text not null,
    name text null,
    area text not null,
    constraint ge_subareas_pkey primary key (subarea),
    constraint ge_subareas_area_fkey foreign key (area) references ge_areas (area) on update cascade on delete cascade
  ) tablespace pg_default;

create table
  public.colleges (
    prefix text not null,
    name text not null,
    constraint colleges_pkey primary key (prefix)
  ) tablespace pg_default;

create table
  public.course_requisites (
    set_number integer generated by default as identity not null,
    course_set_number integer not null,
    type public.requisite_type not null,
    constraint course_requisites_pkey primary key (set_number),
    constraint course_requisites_course_set_number_fkey foreign key (course_set_number) references course_sets (set_number) on update cascade on delete cascade
  ) tablespace pg_default;

create table
  public.departments (
    id integer generated by default as identity not null,
    name text not null,
    constraint departments_pkey primary key (id)
  ) tablespace pg_default;

create table
  public.programs (
    id integer generated by default as identity not null,
    name text not null,
    department_id integer not null,
    type public.program_type not null,
    constraint programs_pkey primary key (id),
    constraint programs_department_id_fkey foreign key (department_id) references departments (id) on update cascade on delete cascade
  ) tablespace pg_default;

create table
  public.concentrations (
    id integer generated by default as identity not null,
    program_id integer not null,
    name text not null,
    constraint concentrations_pkey primary key (id),
    constraint concentrations_program_id_fkey foreign key (program_id) references programs (id) on update cascade on delete cascade
  ) tablespace pg_default;

create table
  public.course_string_requisite_sets (
    id integer generated by default as identity not null,
    set_number integer not null,
    requirement text not null,
    constraint course_string_requisite_sets_pkey primary key (id),
    constraint course_string_requisite_sets_set_number_fkey foreign key (set_number) references course_requisites (set_number) on update cascade on delete cascade
  ) tablespace pg_default;

create table
  public.subjects (
    prefix text not null,
    department_id integer null,
    name text not null,
    constraint subjects_pkey primary key (prefix),
    constraint subjects_department_id_fkey foreign key (department_id) references departments (id) on update cascade on delete cascade
  ) tablespace pg_default;

create table
  public.ge_courses (
    id integer generated by default as identity not null,
    course_set_number integer not null,
    subarea text not null,
    constraint courses_ge_pkey primary key (id),
    constraint courses_ge_course_set_number_fkey foreign key (course_set_number) references course_sets (set_number) on update cascade on delete cascade,
    constraint ge_courses_subarea_fkey foreign key (subarea) references ge_subareas (subarea) on update cascade on delete cascade
  ) tablespace pg_default;

create table
  public.courses (
    id integer generated by default as identity not null,
    prefix text not null,
    number integer not null,
    name text not null,
    description text not null,
    min_units integer null,
    max_units integer not null,
    fall boolean not null,
    winter boolean not null,
    spring boolean not null,
    summer boolean not null,
    set_number integer not null,
    uscp boolean not null,
    gwr boolean not null,
    constraint courses_pkey primary key (id),
    constraint course_unique unique (prefix, number),
    constraint courses_prefix_fkey foreign key (prefix) references subjects (prefix) on update cascade on delete cascade,
    constraint courses_set_number_fkey foreign key (set_number) references course_sets (set_number) on update cascade on delete cascade
  ) tablespace pg_default;

create table
  public.program_requirements (
    requirement_group integer generated by default as identity not null,
    min_units integer null,
    max_units integer not null,
    program_id integer not null,
    header text not null,
    constraint program_requirements_pkey primary key (requirement_group),
    constraint program_requirements_program_id_fkey foreign key (program_id) references programs (id) on update cascade on delete cascade
  ) tablespace pg_default;

create table
  public.program_requirement_ges (
    id bigint generated by default as identity not null,
    requirement_group integer not null,
    ge_subarea text not null,
    different_prefixs integer null,
    constraint program_requirements_ge_pkey primary key (id),
    constraint program_requirements_ge_ge_subarea_fkey foreign key (ge_subarea) references ge_subareas (subarea),
    constraint program_requirements_ge_requirement_group_fkey foreign key (requirement_group) references program_requirements (requirement_group) on update cascade on delete cascade
  ) tablespace pg_default; q

create table
  public.program_requirement_sets (
    set_number integer generated by default as identity not null,
    requirement_group integer not null,
    constraint program_requirement_sets_pkey primary key (set_number),
    constraint program_requirement_sets_requirement_group_fkey foreign key (requirement_group) references program_requirements (requirement_group) on update cascade on delete cascade
  ) tablespace pg_default;

create table
  public.program_requirement_courses (
    id integer generated by default as identity not null,
    set_number integer not null,
    course_set_number integer not null,
    constraint program_requirement_courses_pkey primary key (id),
    constraint program_requirement_courses_course_set_number_fkey2 foreign key (course_set_number) references course_sets (set_number) on update cascade on delete cascade,
    constraint program_requirement_courses_set_number_fkey1 foreign key (set_number) references program_requirement_sets (set_number) on update cascade on delete cascade
  ) tablespace pg_default;

create table
  public.user_plans (
    id integer generated by default as identity not null,
    graduation_date date null,
    concentration_id integer not null,
    program_id integer not null,
    user_id uuid not null,
    constraint user_plans_pkey primary key (id),
    constraint user_plans_concentration_id_fkey foreign key (concentration_id) references concentrations (id) on update cascade on delete cascade,
    constraint user_plans_program_id_fkey foreign key (program_id) references programs (id) on update cascade on delete cascade,
    constraint user_plans_user_id_fkey foreign key (user_id) references auth.users (id) on update cascade on delete cascade
  ) tablespace pg_default;

create table
  public.course_requisite_sets (
    id integer generated by default as identity not null,
    set_number integer not null,
    course_set_number integer not null,
    constraint course_requisite_sets_pkey primary key (id),
    constraint course_requisite_sets_course_set_number_fkey foreign key (course_set_number) references course_sets (set_number) on update cascade on delete cascade,
    constraint course_requisite_sets_set_number_fkey foreign key (set_number) references course_requisites (set_number) on update cascade on delete cascade
  ) tablespace pg_default;

create table
  public.user_course_history (
    user_id bigint generated by default as identity not null,
    course_id integer not null,
    in_progress boolean not null,
    constraint user_course_history_pkey primary key (user_id),
    constraint user_course_history_course_id_fkey foreign key (course_id) references courses (id) on update cascade on delete cascade
  ) tablespace pg_default;

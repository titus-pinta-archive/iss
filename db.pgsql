--
-- PostgreSQL database dump
--

-- Dumped from database version 11.2
-- Dumped by pg_dump version 11.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: book; Type: TABLE; Schema: public; Owner: titus
--

CREATE TABLE public.book (
    id uuid NOT NULL,
    title character varying(255) NOT NULL,
    author character varying(255) NOT NULL,
    image character varying(255)
);


ALTER TABLE public.book OWNER TO titus;

--
-- Name: individual_book; Type: TABLE; Schema: public; Owner: titus
--

CREATE TABLE public.individual_book (
    id uuid NOT NULL,
    book_id uuid
);


ALTER TABLE public.individual_book OWNER TO titus;

--
-- Name: loan_event; Type: TABLE; Schema: public; Owner: titus
--

CREATE TABLE public.loan_event (
    id uuid NOT NULL,
    individual_book_id uuid,
    user_id uuid,
    event_type character varying(255),
    created timestamp without time zone
);


ALTER TABLE public.loan_event OWNER TO titus;

--
-- Name: reader; Type: TABLE; Schema: public; Owner: titus
--

CREATE TABLE public.reader (
    id uuid NOT NULL,
    email character varying(255) NOT NULL,
    pass character varying(255) NOT NULL,
    cnp character varying(255) NOT NULL,
    address character varying(255) NOT NULL,
    phone character varying(255) NOT NULL
);


ALTER TABLE public.reader OWNER TO titus;

--
-- Name: user; Type: TABLE; Schema: public; Owner: titus
--

CREATE TABLE public."user" (
    id bigint NOT NULL,
    name character varying(255)
);


ALTER TABLE public."user" OWNER TO titus;

--
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: titus
--

CREATE SEQUENCE public.user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_id_seq OWNER TO titus;

--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: titus
--

ALTER SEQUENCE public.user_id_seq OWNED BY public."user".id;


--
-- Name: user id; Type: DEFAULT; Schema: public; Owner: titus
--

ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);


--
-- Data for Name: book; Type: TABLE DATA; Schema: public; Owner: titus
--

COPY public.book (id, title, author, image) FROM stdin;
6779d39a-d192-43cc-9541-49e48f2e66af	Poezii	M. Eminescu	Prost
67f6ad77-8388-4ab2-88ce-cd1df4fdaa45	Harap Alb	I. Creanga	Poza
4f0028f3-7aeb-42cb-b939-eded062df6da	Necuvintele	Nichita	Poza
\.


--
-- Data for Name: individual_book; Type: TABLE DATA; Schema: public; Owner: titus
--

COPY public.individual_book (id, book_id) FROM stdin;
d3fd69b6-776a-48d4-ae90-7ad84acaa4fe	744de319-75a6-4067-9ae4-9cc8716d1853
6e84692c-6609-4afe-a43c-0aa279a286bd	744de319-75a6-4067-9ae4-9cc8716d1853
7ab7d94c-0820-4567-a61e-587480f6da81	744de319-75a6-4067-9ae4-9cc8716d1853
993e1e80-6c52-453f-850b-3351f7811273	744de319-75a6-4067-9ae4-9cc8716d1853
58773a4b-abeb-4f4d-a58b-7e2aa27f9dfc	6779d39a-d192-43cc-9541-49e48f2e66af
dee5b61d-5031-4461-8782-3d512d563bf6	6779d39a-d192-43cc-9541-49e48f2e66af
b4c59eec-8f74-416f-b999-6f5ad0bbd913	6779d39a-d192-43cc-9541-49e48f2e66af
64c368f9-d42c-44bf-8510-b44bac661c4d	6779d39a-d192-43cc-9541-49e48f2e66af
08dcfa90-8ee2-4156-913c-9fbd095db9d9	67f6ad77-8388-4ab2-88ce-cd1df4fdaa45
bdcf45b2-d71e-4149-9b8b-9b0f09906ca5	67f6ad77-8388-4ab2-88ce-cd1df4fdaa45
5207df5d-340d-40ca-8241-f569ebfc192c	67f6ad77-8388-4ab2-88ce-cd1df4fdaa45
50cfe769-2921-4e7e-921d-e9ce431802cf	4f0028f3-7aeb-42cb-b939-eded062df6da
bf02ec6c-af9c-4264-95eb-d1074552bf62	4f0028f3-7aeb-42cb-b939-eded062df6da
69df1cf8-5b93-464f-9261-bd4939194f5e	4f0028f3-7aeb-42cb-b939-eded062df6da
965f0d11-577c-45b0-82bd-02acea7a05a1	4f0028f3-7aeb-42cb-b939-eded062df6da
fd829eff-f64a-473a-9480-f62ad8f8b721	4f0028f3-7aeb-42cb-b939-eded062df6da
48b62297-c4fc-47bb-8356-c38bbc0b12f4	4f0028f3-7aeb-42cb-b939-eded062df6da
\.


--
-- Data for Name: loan_event; Type: TABLE DATA; Schema: public; Owner: titus
--

COPY public.loan_event (id, individual_book_id, user_id, event_type, created) FROM stdin;
56739a78-a9ab-4caf-afc7-b3a0c9c2f02e	58773a4b-abeb-4f4d-a58b-7e2aa27f9dfc	607c53a8-1182-4eda-8992-763e762929fe	borrow	2019-05-14 02:10:02
ed1528f2-8101-4fca-8c2a-9416d713bd12	08dcfa90-8ee2-4156-913c-9fbd095db9d9	607c53a8-1182-4eda-8992-763e762929fe	borrow	2019-05-14 02:10:05
cad13882-8a1e-4fce-8fea-de1cc6eef672	58773a4b-abeb-4f4d-a58b-7e2aa27f9dfc	607c53a8-1182-4eda-8992-763e762929fe	return	2019-05-14 02:10:26
275a35bf-85a7-4b0b-a593-d25fcc99f9f3	58773a4b-abeb-4f4d-a58b-7e2aa27f9dfc	607c53a8-1182-4eda-8992-763e762929fe	borrow	2019-05-14 02:10:28
be8f404f-8280-493a-b4af-0097404f1e75	bdcf45b2-d71e-4149-9b8b-9b0f09906ca5	607c53a8-1182-4eda-8992-763e762929fe	borrow	2019-05-14 02:10:30
3eaeb047-90d8-463d-8e64-7a3e0fa6dcec	50cfe769-2921-4e7e-921d-e9ce431802cf	607c53a8-1182-4eda-8992-763e762929fe	borrow	2019-05-14 02:10:33
a0fa8a1d-3b88-4ffc-afc7-83227037c73a	bf02ec6c-af9c-4264-95eb-d1074552bf62	607c53a8-1182-4eda-8992-763e762929fe	borrow	2019-05-14 02:10:38
6d9bcff6-90bf-4de4-ab44-8cff94844a94	69df1cf8-5b93-464f-9261-bd4939194f5e	607c53a8-1182-4eda-8992-763e762929fe	borrow	2019-05-14 02:10:41
ebb405e4-dcd0-4bb0-ae05-f0c98f849f66	965f0d11-577c-45b0-82bd-02acea7a05a1	607c53a8-1182-4eda-8992-763e762929fe	borrow	2019-05-14 02:10:43
5e92f237-1ed7-4c13-b9e0-a0f9a7294da7	dee5b61d-5031-4461-8782-3d512d563bf6	607c53a8-1182-4eda-8992-763e762929fe	borrow	2019-05-14 02:10:55
dc4520b8-a847-457d-b2fc-d656579b5223	b4c59eec-8f74-416f-b999-6f5ad0bbd913	607c53a8-1182-4eda-8992-763e762929fe	borrow	2019-05-14 02:11:01
26470476-9d87-47e5-9e40-53eba92c8f47	64c368f9-d42c-44bf-8510-b44bac661c4d	607c53a8-1182-4eda-8992-763e762929fe	borrow	2019-05-14 02:11:12
886f6685-d2ae-41d5-976c-8106319c6c84	5207df5d-340d-40ca-8241-f569ebfc192c	607c53a8-1182-4eda-8992-763e762929fe	borrow	2019-05-14 02:11:43
9c71fb3b-e983-4a6f-b0ce-b328557814ce	fd829eff-f64a-473a-9480-f62ad8f8b721	607c53a8-1182-4eda-8992-763e762929fe	borrow	2019-05-14 02:12:02
e39192cd-784e-4040-a504-eceb512115df	48b62297-c4fc-47bb-8356-c38bbc0b12f4	607c53a8-1182-4eda-8992-763e762929fe	borrow	2019-05-14 02:12:40
f3a7c36f-9584-404a-988e-2609f2cb3526	58773a4b-abeb-4f4d-a58b-7e2aa27f9dfc	607c53a8-1182-4eda-8992-763e762929fe	return	2019-05-14 02:13:05
501f437d-e7a1-475d-a970-37b2c4deff16	dee5b61d-5031-4461-8782-3d512d563bf6	607c53a8-1182-4eda-8992-763e762929fe	return	2019-05-14 02:13:08
e87fb38e-e5c5-4de6-90d7-44d81bcd1afa	b4c59eec-8f74-416f-b999-6f5ad0bbd913	607c53a8-1182-4eda-8992-763e762929fe	return	2019-05-14 02:13:13
7e14e74a-8244-434f-862a-d7293ff5d8e9	64c368f9-d42c-44bf-8510-b44bac661c4d	607c53a8-1182-4eda-8992-763e762929fe	return	2019-05-14 02:13:17
3508eda9-dd54-47b9-a7a8-9ef2adb13756	08dcfa90-8ee2-4156-913c-9fbd095db9d9	607c53a8-1182-4eda-8992-763e762929fe	return	2019-05-14 02:13:19
05124a3b-8dcd-4362-83dc-c6ca55659b94	bdcf45b2-d71e-4149-9b8b-9b0f09906ca5	607c53a8-1182-4eda-8992-763e762929fe	return	2019-05-14 02:13:22
f9137906-bcdd-4bd2-8104-ff8f416bb558	5207df5d-340d-40ca-8241-f569ebfc192c	607c53a8-1182-4eda-8992-763e762929fe	return	2019-05-14 02:13:24
081604fc-aece-45ff-a1ec-519965f42655	50cfe769-2921-4e7e-921d-e9ce431802cf	607c53a8-1182-4eda-8992-763e762929fe	return	2019-05-14 02:13:27
a9db21c8-b503-40ce-819a-94a04dd3e5b8	bf02ec6c-af9c-4264-95eb-d1074552bf62	607c53a8-1182-4eda-8992-763e762929fe	return	2019-05-14 02:13:29
5fd4f4b9-4993-49b3-a250-9620bb6c45a2	69df1cf8-5b93-464f-9261-bd4939194f5e	607c53a8-1182-4eda-8992-763e762929fe	return	2019-05-14 02:13:32
5f725e9b-9353-4e24-956c-cab4ea68ab64	965f0d11-577c-45b0-82bd-02acea7a05a1	607c53a8-1182-4eda-8992-763e762929fe	return	2019-05-14 02:13:34
94e495cd-122f-450b-a537-576b5550189b	fd829eff-f64a-473a-9480-f62ad8f8b721	607c53a8-1182-4eda-8992-763e762929fe	return	2019-05-14 02:13:36
d9bb52bc-c7de-4959-b675-bfceb9e84a54	48b62297-c4fc-47bb-8356-c38bbc0b12f4	607c53a8-1182-4eda-8992-763e762929fe	return	2019-05-14 02:13:38
0cd23dd5-b738-4b6f-8a91-5c4404bd6e5e	08dcfa90-8ee2-4156-913c-9fbd095db9d9	607c53a8-1182-4eda-8992-763e762929fe	borrow	2019-05-14 02:13:42
d20818f7-6082-4249-aca8-d92adc7fbc82	bdcf45b2-d71e-4149-9b8b-9b0f09906ca5	607c53a8-1182-4eda-8992-763e762929fe	borrow	2019-05-14 02:13:52
66cdb17b-4ae2-4988-a009-76cfaab09f5c	50cfe769-2921-4e7e-921d-e9ce431802cf	607c53a8-1182-4eda-8992-763e762929fe	borrow	2019-05-14 02:16:52
3e130c87-3f07-40f8-9b7d-3dce20c80d79	08dcfa90-8ee2-4156-913c-9fbd095db9d9	607c53a8-1182-4eda-8992-763e762929fe	return	2019-05-14 02:17:01
90edf2fc-a973-4bf3-90f0-72c3fcb0cfb7	bdcf45b2-d71e-4149-9b8b-9b0f09906ca5	607c53a8-1182-4eda-8992-763e762929fe	return	2019-05-14 02:17:04
4d45b591-d5c7-4c0e-87b6-17d46607c725	50cfe769-2921-4e7e-921d-e9ce431802cf	607c53a8-1182-4eda-8992-763e762929fe	return	2019-05-14 02:17:06
af272c4e-232f-41ce-960f-2034ee7fef03	58773a4b-abeb-4f4d-a58b-7e2aa27f9dfc	607c53a8-1182-4eda-8992-763e762929fe	borrow	2019-05-14 02:17:08
704729d0-7ffb-47cc-9bd7-1747958bbdec	dee5b61d-5031-4461-8782-3d512d563bf6	607c53a8-1182-4eda-8992-763e762929fe	borrow	2019-05-14 02:17:10
3d0d20c8-fcaa-408b-90d4-b3b957081d19	58773a4b-abeb-4f4d-a58b-7e2aa27f9dfc	607c53a8-1182-4eda-8992-763e762929fe	return	2019-05-14 02:17:13
83b7908c-a75f-41a6-b340-154509464e29	dee5b61d-5031-4461-8782-3d512d563bf6	607c53a8-1182-4eda-8992-763e762929fe	return	2019-05-14 02:17:15
f40f180d-c510-4ad7-9506-4aca2a5556f9	58773a4b-abeb-4f4d-a58b-7e2aa27f9dfc	607c53a8-1182-4eda-8992-763e762929fe	borrow	2019-05-14 02:17:17
da0639d5-b5b6-44ad-b467-25af6a1a1476	dee5b61d-5031-4461-8782-3d512d563bf6	607c53a8-1182-4eda-8992-763e762929fe	borrow	2019-05-14 02:17:19
eadf9251-11ae-49c6-9c01-ff007a364e1e	b4c59eec-8f74-416f-b999-6f5ad0bbd913	607c53a8-1182-4eda-8992-763e762929fe	borrow	2019-05-14 02:18:17
478c339e-4315-4528-a638-2479d4c4d05c	58773a4b-abeb-4f4d-a58b-7e2aa27f9dfc	607c53a8-1182-4eda-8992-763e762929fe	return	2019-05-14 02:18:20
4f8c0f48-f880-40f8-8b38-8cd196672094	dee5b61d-5031-4461-8782-3d512d563bf6	607c53a8-1182-4eda-8992-763e762929fe	return	2019-05-14 02:18:23
492af928-05e3-4821-9f2c-30b31ef06fe6	58773a4b-abeb-4f4d-a58b-7e2aa27f9dfc	607c53a8-1182-4eda-8992-763e762929fe	borrow	2019-05-14 02:18:26
d9a38578-b13f-4977-9e25-c642c3b95fef	58773a4b-abeb-4f4d-a58b-7e2aa27f9dfc	607c53a8-1182-4eda-8992-763e762929fe	return	2019-05-14 02:20:45
214b0326-b76f-47a1-b9ea-de943038c489	b4c59eec-8f74-416f-b999-6f5ad0bbd913	607c53a8-1182-4eda-8992-763e762929fe	return	2019-05-14 02:20:48
ec7cab0c-3b1b-4f5c-ad8f-3db24bb6d9d0	58773a4b-abeb-4f4d-a58b-7e2aa27f9dfc	607c53a8-1182-4eda-8992-763e762929fe	borrow	2019-05-14 02:20:50
ffb28476-180e-4122-9ecc-9cb3bb5c8da9	dee5b61d-5031-4461-8782-3d512d563bf6	607c53a8-1182-4eda-8992-763e762929fe	borrow	2019-05-14 02:29:31
53da7ad5-91b8-4451-9d8e-f07e3aa5d93d	58773a4b-abeb-4f4d-a58b-7e2aa27f9dfc	607c53a8-1182-4eda-8992-763e762929fe	return	2019-05-14 02:30:57
b70cd1f7-d883-4945-9c41-d2bb198d2466	dee5b61d-5031-4461-8782-3d512d563bf6	607c53a8-1182-4eda-8992-763e762929fe	return	2019-05-14 02:30:59
91f2ad03-5a01-4f9c-9f77-957994883e12	58773a4b-abeb-4f4d-a58b-7e2aa27f9dfc	607c53a8-1182-4eda-8992-763e762929fe	borrow	2019-05-14 11:37:10
d9b0c79e-11de-4014-8243-c57935de8f3f	dee5b61d-5031-4461-8782-3d512d563bf6	607c53a8-1182-4eda-8992-763e762929fe	borrow	2019-05-14 11:37:15
5801372d-1d9d-4bd1-8393-8287332c790e	58773a4b-abeb-4f4d-a58b-7e2aa27f9dfc	607c53a8-1182-4eda-8992-763e762929fe	return	2019-05-14 11:37:18
656b0c6a-d87c-4a51-bc4d-969fdfed068f	dee5b61d-5031-4461-8782-3d512d563bf6	607c53a8-1182-4eda-8992-763e762929fe	return	2019-05-14 11:37:21
8e7127ae-d3bf-4d60-a3fb-b480e3cc2e2a	58773a4b-abeb-4f4d-a58b-7e2aa27f9dfc	607c53a8-1182-4eda-8992-763e762929fe	borrow	2019-05-14 11:37:24
640c9ae0-3669-4b86-bd92-dcee02c7a3fc	dee5b61d-5031-4461-8782-3d512d563bf6	607c53a8-1182-4eda-8992-763e762929fe	borrow	2019-05-14 11:37:27
e45c89e9-6844-4856-82d2-a9e3b9f1c7e3	58773a4b-abeb-4f4d-a58b-7e2aa27f9dfc	607c53a8-1182-4eda-8992-763e762929fe	return	2019-05-14 11:53:29
8c9d0a70-441e-47b6-8c60-fbd6a2afb945	dee5b61d-5031-4461-8782-3d512d563bf6	607c53a8-1182-4eda-8992-763e762929fe	return	2019-05-14 11:53:31
de4fef9e-ceb8-4c44-ae50-c908e785a7a4	58773a4b-abeb-4f4d-a58b-7e2aa27f9dfc	607c53a8-1182-4eda-8992-763e762929fe	borrow	2019-05-14 11:53:35
331ecd9f-0700-462e-8738-954bac982a93	dee5b61d-5031-4461-8782-3d512d563bf6	607c53a8-1182-4eda-8992-763e762929fe	borrow	2019-05-14 11:53:38
32c77249-6e5f-405a-a482-32c5ea1be522	b4c59eec-8f74-416f-b999-6f5ad0bbd913	607c53a8-1182-4eda-8992-763e762929fe	borrow	2019-05-14 12:14:01
a7d70257-bb44-496b-ba3e-f772da0106cf	58773a4b-abeb-4f4d-a58b-7e2aa27f9dfc	607c53a8-1182-4eda-8992-763e762929fe	return	2019-05-14 12:14:14
b42eabd1-75be-44e1-81e8-2ab7282bd09f	dee5b61d-5031-4461-8782-3d512d563bf6	607c53a8-1182-4eda-8992-763e762929fe	return	2019-05-14 12:14:17
6c267e93-b48b-49bf-b379-5d5c9541ce4c	b4c59eec-8f74-416f-b999-6f5ad0bbd913	607c53a8-1182-4eda-8992-763e762929fe	return	2019-05-14 12:14:20
7a5a812b-6da6-45fb-b9f9-ca0ce4e89bc1	58773a4b-abeb-4f4d-a58b-7e2aa27f9dfc	607c53a8-1182-4eda-8992-763e762929fe	borrow	2019-05-14 12:15:50
89697044-6d2d-46a0-853a-e2066301cfde	58773a4b-abeb-4f4d-a58b-7e2aa27f9dfc	607c53a8-1182-4eda-8992-763e762929fe	return	2019-05-14 12:16:20
e7826b31-5e01-40d0-8ae3-6396c148e9fe	58773a4b-abeb-4f4d-a58b-7e2aa27f9dfc	607c53a8-1182-4eda-8992-763e762929fe	borrow	2019-05-14 12:16:24
4f9f7b90-c0d7-4f02-8af1-2ab7c14217f2	dee5b61d-5031-4461-8782-3d512d563bf6	607c53a8-1182-4eda-8992-763e762929fe	borrow	2019-05-14 12:16:27
123912f2-b491-4424-b7df-7ef6fcc4e3bb	b4c59eec-8f74-416f-b999-6f5ad0bbd913	607c53a8-1182-4eda-8992-763e762929fe	borrow	2019-05-14 12:25:18
65ffcfb1-3def-498c-98d7-0fd14949af77	b4c59eec-8f74-416f-b999-6f5ad0bbd913	607c53a8-1182-4eda-8992-763e762929fe	return	2019-05-14 12:25:22
ef47dabd-daf9-43be-858e-cf40060c2a52	58773a4b-abeb-4f4d-a58b-7e2aa27f9dfc	607c53a8-1182-4eda-8992-763e762929fe	return	2019-05-14 12:25:24
11b11946-3b8e-4d4b-8cae-14b2a3d7d739	58773a4b-abeb-4f4d-a58b-7e2aa27f9dfc	607c53a8-1182-4eda-8992-763e762929fe	borrow	2019-05-14 12:25:29
7f8a6f25-ea9a-496b-af53-b506d0879fe2	58773a4b-abeb-4f4d-a58b-7e2aa27f9dfc	607c53a8-1182-4eda-8992-763e762929fe	return	2019-05-14 12:25:32
65f9ff64-4408-4ab2-a48d-3ecad8f3b75d	08dcfa90-8ee2-4156-913c-9fbd095db9d9	607c53a8-1182-4eda-8992-763e762929fe	borrow	2019-05-14 12:25:41
baf89e80-62c0-4cf3-89b0-179874501d00	08dcfa90-8ee2-4156-913c-9fbd095db9d9	607c53a8-1182-4eda-8992-763e762929fe	return	2019-05-14 12:25:45
457f9f41-c62f-4f23-8e0c-36bf22f49bf3	08dcfa90-8ee2-4156-913c-9fbd095db9d9	607c53a8-1182-4eda-8992-763e762929fe	borrow	2019-05-14 12:25:48
dfd60172-d0e1-428b-a858-b803968801d9	50cfe769-2921-4e7e-921d-e9ce431802cf	607c53a8-1182-4eda-8992-763e762929fe	borrow	2019-05-14 12:25:51
9befd176-cefc-492b-9598-c30db34f566b	58773a4b-abeb-4f4d-a58b-7e2aa27f9dfc	607c53a8-1182-4eda-8992-763e762929fe	borrow	2019-05-14 12:26:36
800c9f7f-742b-461b-8038-1fb4dc01251f	08dcfa90-8ee2-4156-913c-9fbd095db9d9	607c53a8-1182-4eda-8992-763e762929fe	return	2019-05-14 12:26:41
c90dac45-d94c-4191-b5f2-8f80f47c35a3	58773a4b-abeb-4f4d-a58b-7e2aa27f9dfc	607c53a8-1182-4eda-8992-763e762929fe	return	2019-05-14 12:26:44
85d588cf-33f2-44fa-af50-57831b25030f	dee5b61d-5031-4461-8782-3d512d563bf6	607c53a8-1182-4eda-8992-763e762929fe	return	2019-05-14 12:26:47
8d616026-122e-4923-900e-b52e35801046	50cfe769-2921-4e7e-921d-e9ce431802cf	607c53a8-1182-4eda-8992-763e762929fe	return	2019-05-14 12:26:49
fd4cd00d-af7a-42b8-990e-01f88ee6c459	58773a4b-abeb-4f4d-a58b-7e2aa27f9dfc	607c53a8-1182-4eda-8992-763e762929fe	borrow	2019-05-14 12:26:53
6af37add-a417-4432-9e33-574bd887047b	58773a4b-abeb-4f4d-a58b-7e2aa27f9dfc	607c53a8-1182-4eda-8992-763e762929fe	return	2019-05-14 12:33:27
83502b4b-aba9-4cee-afcf-0e4c2e39f3fa	58773a4b-abeb-4f4d-a58b-7e2aa27f9dfc	607c53a8-1182-4eda-8992-763e762929fe	borrow	2019-05-14 12:33:30
689199b1-f98e-459d-8909-10bb9a0869bf	dee5b61d-5031-4461-8782-3d512d563bf6	607c53a8-1182-4eda-8992-763e762929fe	borrow	2019-05-14 12:33:34
f53be216-cbce-45bb-9cb1-65ff24a6a9c9	b4c59eec-8f74-416f-b999-6f5ad0bbd913	607c53a8-1182-4eda-8992-763e762929fe	borrow	2019-05-14 12:33:36
0120be53-0bff-4ca5-a141-31814adae885	b4c59eec-8f74-416f-b999-6f5ad0bbd913	607c53a8-1182-4eda-8992-763e762929fe	return	2019-05-14 12:33:39
68dbf47e-c32e-4a83-9603-c9cb68610ea8	58773a4b-abeb-4f4d-a58b-7e2aa27f9dfc	607c53a8-1182-4eda-8992-763e762929fe	return	2019-05-14 12:33:42
03028d04-85f1-4330-bc89-d82cc90b1959	58773a4b-abeb-4f4d-a58b-7e2aa27f9dfc	607c53a8-1182-4eda-8992-763e762929fe	borrow	2019-05-14 12:33:45
ab0afe43-bbfc-4935-9731-13f7b0cf4b15	08dcfa90-8ee2-4156-913c-9fbd095db9d9	607c53a8-1182-4eda-8992-763e762929fe	borrow	2019-05-14 12:33:48
fbec1f6c-a639-40ac-a962-71429a6dcfbd	08dcfa90-8ee2-4156-913c-9fbd095db9d9	607c53a8-1182-4eda-8992-763e762929fe	return	2019-05-14 12:33:50
1241a45b-8b10-463e-aede-9d63c09468dd	58773a4b-abeb-4f4d-a58b-7e2aa27f9dfc	607c53a8-1182-4eda-8992-763e762929fe	return	2019-05-14 12:34:01
f506bd2a-2918-40ec-85fb-d9631b87f8ac	dee5b61d-5031-4461-8782-3d512d563bf6	607c53a8-1182-4eda-8992-763e762929fe	return	2019-05-14 12:34:05
c3ef3395-4689-466f-aef4-0d03360aa69d	58773a4b-abeb-4f4d-a58b-7e2aa27f9dfc	607c53a8-1182-4eda-8992-763e762929fe	borrow	2019-05-14 12:52:22
0c286bb7-1672-4aba-bdc6-f32d0c68d071	58773a4b-abeb-4f4d-a58b-7e2aa27f9dfc	607c53a8-1182-4eda-8992-763e762929fe	return	2019-05-14 12:52:26
e0ff4572-47a2-485f-8a25-321765d6d1cf	58773a4b-abeb-4f4d-a58b-7e2aa27f9dfc	607c53a8-1182-4eda-8992-763e762929fe	borrow	2019-05-14 12:53:00
9dbeee50-31a5-4e6e-b161-43035632b033	58773a4b-abeb-4f4d-a58b-7e2aa27f9dfc	607c53a8-1182-4eda-8992-763e762929fe	return	2019-05-14 12:53:03
\.


--
-- Data for Name: reader; Type: TABLE DATA; Schema: public; Owner: titus
--

COPY public.reader (id, email, pass, cnp, address, phone) FROM stdin;
607c53a8-1182-4eda-8992-763e762929fe	titus.pinta@gmail.com	titus	12345	l. da vinci	112
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: titus
--

COPY public."user" (id, name) FROM stdin;
1	xlw
4	xlw
\.


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: titus
--

SELECT pg_catalog.setval('public.user_id_seq', 1, false);


--
-- Name: book book_pkey; Type: CONSTRAINT; Schema: public; Owner: titus
--

ALTER TABLE ONLY public.book
    ADD CONSTRAINT book_pkey PRIMARY KEY (id);


--
-- Name: individual_book individual_book_pkey; Type: CONSTRAINT; Schema: public; Owner: titus
--

ALTER TABLE ONLY public.individual_book
    ADD CONSTRAINT individual_book_pkey PRIMARY KEY (id);


--
-- Name: loan_event loan_event_pkey; Type: CONSTRAINT; Schema: public; Owner: titus
--

ALTER TABLE ONLY public.loan_event
    ADD CONSTRAINT loan_event_pkey PRIMARY KEY (id);


--
-- Name: reader reader_pkey; Type: CONSTRAINT; Schema: public; Owner: titus
--

ALTER TABLE ONLY public.reader
    ADD CONSTRAINT reader_pkey PRIMARY KEY (id);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: titus
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: UQE_book_title; Type: INDEX; Schema: public; Owner: titus
--

CREATE UNIQUE INDEX "UQE_book_title" ON public.book USING btree (title);


--
-- Name: UQE_reader_cnp; Type: INDEX; Schema: public; Owner: titus
--

CREATE UNIQUE INDEX "UQE_reader_cnp" ON public.reader USING btree (cnp);


--
-- Name: UQE_reader_email; Type: INDEX; Schema: public; Owner: titus
--

CREATE UNIQUE INDEX "UQE_reader_email" ON public.reader USING btree (email);


--
-- PostgreSQL database dump complete
--


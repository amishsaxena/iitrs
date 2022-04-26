CREATE INDEX idx_train_no_h ON train_journey USING hash (train_no);

CREATE INDEX idx_src_dest_h ON route (source, destination);

CREATE INDEX idx_email_pwd ON user_info (email, password);

CREATE INDEX idx_email ON user_info (email);

CREATE INDEX idx_av_first_ac ON availability USING btree (first_ac);
CREATE INDEX idx_av_second_ac ON availability USING btree (second_ac);
CREATE INDEX idx_av_third_ac ON availability USING btree (third_ac);
CREATE INDEX idx_av_sleeper ON availability USING btree (sleeper);
CREATE INDEX idx_av_general ON availability USING btree (general);

CREATE INDEX idx_pnr_hash ON ticket USING hash (pnr);